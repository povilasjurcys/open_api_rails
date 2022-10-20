# frozen_string_literal: true

require 'open_api_rails/attributes/graphql_attribute_parser'

module OpenApiRails
  module Controller
    # Configures OpenApiRails::Controller::Action based on GraphqlRails::Action configuration.
    class ConfigureActionFromGraphql
      def self.call(**kwargs)
        new(**kwargs).call
      end

      def initialize(action_configuration:, graphql_action_name:)
        @action_configuration = action_configuration
        @graphql_action_name = graphql_action_name
      end

      def call
        configure_description
        configure_type
        configure_arguments
        configure_query_parameters

        action_configuration
      end

      private

      attr_reader :action_configuration, :graphql_action_name

      def configure_description
        description = graphql.description
        return if description.blank?

        action_configuration.summary(description)
        action_configuration.description(description)
      end

      def configure_type
        graphql_type = graphql.type_parser.send(:unparsed_type)
        action_configuration.type(graphql_type)
      end

      def configure_arguments
        graphql.attributes.each_value { configure_argument(_1) }
      end

      def configure_query_parameters
        type_name = action_configuration.nullable_inner_type_name
        enum_values = action_configuration.type_parser.open_api_model_configuration.attributes.keys

        action_configuration.argument("fields[#{type_name}]').tap do |arg|
          arg.type('array')
          arg.items.type('string').enum(enum_values)

          arg.description('Comma separated list of #/components/schemas/#{type_name} fields that must be returned')

          arg.in_query
          arg.style('simple')
          arg.explode(false)
        end
      end

      def configure_argument(graphql_attribute)
        type = open_api_type_for(graphql_attribute)

        argument = action_configuration.argument(graphql_attribute.field_name)
        argument.type(type).graphql_subtype(graphql_attribute.subtype)
        configure_argument_location(argument)
      end

      def configure_argument_location(argument)
        if argument.name == 'id'
          argument.in_path
        else
          argument.in_request_body
        end
      end

      def open_api_type_for(graphql_attribute)
        attribute_parser = ::OpenApiRails::Attributes::GraphqlAttributeParser
        attribute_parser.new(graphql_attribute).open_api_type
      end

      def graphql
        @graphql ||= extract_graphql_configuration
      end

      def extract_graphql_configuration
        graphql_path = graphql_route.path
        controller_name, action = graphql_path.split('#')
        graphql_controller = "#{controller_name}_controller".classify.safe_constantize
        graphql_controller.action(action.to_sym)
      end

      def graphql_route
        @graphql_route ||= GraphqlRouter.routes.index_by(&:name).fetch(graphql_action_name.to_s)
      end
    end
  end
end
