# frozen_string_literal: true

require 'graphql_to_rest/open_api/controller/controller_configuration'

module GraphqlToRest
  module OpenApi
    # Contains configuration
    module Controller
      # Configuration for a controller action
      module ClassMethods
        def open_api
          @open_api ||= ControllerConfiguration.new
          yield(@open_api) if block_given?
          @open_api
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end

      private

      def graphql_action_name
        open_api_action.graphql_action
      end

      def initial_action_mutation
        graphql.mutation(graphql_action_name)
      end

      def initial_action_query
        graphql.query(graphql_action_name)
      end

      def action_mutation
        initial_action_mutation
          .input(action_input_fields)
          .output(action_output_fields)
      end

      def action_output_fields
        [:id, :__typename, *fieldset]
      end

      def action_input_fields
        fields = params.dig(:data, :attributes).to_h.symbolize_keys
        if open_api_action.graphql_input_type_path.present?
          {}.set(*open_api_action.graphql_input_type_path, fields)
        else
          fields
        end
      end

      def fieldset
        fieldset_name = open_api_action.fieldset_parameter.name
        fieldset_name ||= "fields[#{open_api.model}]" if open_api.model

        params[fieldset_name].to_s.split(',').presence || open_api_action.fieldset_parameter.default_value
      end

      def open_api
        self.class.open_api
      end

      def open_api_action
        open_api.action(action_name)
      end
    end
  end
end
