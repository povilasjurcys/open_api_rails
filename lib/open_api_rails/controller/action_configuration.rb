# frozen_string_literal: true

require 'open_api_rails/concerns/chainable_getter_setter'
require 'open_api_rails/concerns/type_configurable'
require 'open_api_rails/controller/argument_configuration'
require 'open_api_rails/controller/configure_action_from_graphql'

module OpenApiRails
  module Controller
    # Stores action configuration for OpenAPI controller
    class ActionConfiguration
      include ::OpenApiRails::ChainableGetterSetter
      include ::OpenApiRails::TypeConfigurable

      chainable_getter_setter :description
      chainable_getter_setter :summary
      chainable_getter_setter :tags
      chainable_getter_setter :type_format

      attr_reader :name, :arguments, :graphql_action_name

      def initialize(name)
        @name = name
        @arguments = {}
      end

      def as_graphql(graphql_action_name)
        @graphql_action_name = graphql_action_name

        ::OpenApiRails::Controller::ConfigureActionFromGraphql.call(
          action_configuration: self,
          graphql_action_name: graphql_action_name
        )
      end

      def argument(name)
        stringified_name = name.to_s
        @arguments[stringified_name] ||= build_argument_configuration(stringified_name)
      end

      def tag(name)
        new_tags = (tags + [name]).uniq
        tags(new_tags)
      end

      def tags(new_tags = nil)
        if new_tags
          @tags = new_tags
        else
          @tags ||= []
        end
      end

      def open_api_json
        {
          **summary_open_api_json,
          **parameters_open_api_json,
          **request_body_open_api_json,
          **responses_open_api_json,
          **tags_open_api_json
        }
      end

      def success_status_code(status_code = nil)
        if status_code
          @success_status_code = status_code
        else
          @success_status_code ||= 200
        end
      end

      def configured?
        type.present?
      end

      def type_parser
        @type_parser ||= ::OpenApiRails::Model::AttributeTypeParser.new(unparsed_type: type)
      end

      def configured_arguments
        arguments.values.select(&:configured?)
      end

      def parameter_arguments
        configured_arguments.select { _1.in_query? || _1.in_path? }
      end

      def request_body_arguments
        configured_arguments.select(&:in_request_body?)
      end

      private

      attr_reader :controller_configuration

      def responses_open_api_json
        responses = {
          **success_response_open_api_json
        }

        return {} if responses.empty?

        { responses: responses }
      end

      def success_response_open_api_json
        response_json = {
          **description_open_api_json,
          **success_response_content_open_api_json
        }.compact

        return {} if response_json.empty?

        { success_status_code.to_s => response_json }
      end

      def success_response_content_open_api_json
        return {} if type.blank?

        schema = success_schema_open_api_json
        return {} if schema.empty?

        {
          content: {
            'application/json': { schema: schema }
          }
        }
      end

      def request_body_open_api_json
        return {} if request_body_arguments.empty?

        schema_properties = request_body_arguments.index_by(&:name).transform_values(&:schema)
        required_properties = request_body_arguments.select(&:required?).map(&:name)
        {
          requestBody: {
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: schema_properties,
                  required: required_properties.presence
                }.compact
              }
            }
          }
        }
      end

      def parameters_open_api_json
        parameters = parameter_arguments.map(&:parameter_open_api_json)
        return {} if parameters.empty?

        { parameters: parameters }
      end


      def description_open_api_json
        { description: description }.compact
      end

      def success_schema_open_api_json
        {
          **format_open_api_json
        }
      end

      def summary_open_api_json
        { summary: summary }.compact
      end

      def tags_open_api_json
        { tags: tags.presence }.compact
      end

      def build_argument_configuration(name)
        ::OpenApiRails::Controller::ArgumentConfiguration.new(name)
      end
    end
  end
end
