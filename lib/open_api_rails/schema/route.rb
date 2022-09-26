# frozen_string_literal: true

module OpenApiRails
  class Schema
    # Represents an OpenAPI path item
    class Route
      def initialize(route)
        @route = route
      end

      def request_body
        {
          description: request_description,
          content: request_content,
          required: request_required?
        }
      end

      def path
        raw_path = route.path.spec.to_s
        path_without_format = raw_path.sub('(.:format)', '')

        path_without_format.gsub(%r{/:([\w\d_]+)(/|$)}, '/{\1}\2')
      end

      def http_method
        route.verb.downcase.to_sym
      end

      def responses
        {
          '200': {
            description: response_description,
            content: response_content
          }
        }
      end

      def configured?
        action.present?
      end

      def component_schema
        return {} if action.basic_type?

        component_name = action.nullable_inner_type_name
        component_schema = action.type_parser.schema_open_api_json

        { component_name => component_schema }
      end

      def request_body_schemas
        action.arguments.values.map(&:request_body_schema).reduce(:merge)
      end

      def action
        return @action if defined?(@action)

        action_config = controller_open_api&.action(controller_action)
        @action = action_config&.configured? ? action_config : nil
      end

      private

      attr_reader :route

      def controller_open_api
        controller_class.try(:open_api)
      end

      def controller_class
        return @controller_class if defined?(@controller_class)

        controller_name = "#{route.defaults[:controller]}_controller"
        @controller_class = "::#{controller_name.classify}".safe_constantize
      end

      def controller_action
        return @controller_action if defined?(@controller_action)

        @controller_action = route.defaults[:action]
      end

      def request_content
        { 'application/json': { schema: request_schema } }
      end

      def request_required?
        true
      end

      def request_schema
        { "$ref": '#/components/schemas/Pet' }
      end

      def response_description
        '<GRAPHQL_OUTPUT_DESCRIPTION>'
      end

      def response_content
        { 'application/json': { schema: response_schema } }
      end

      def response_schema
        { "$ref": "#/components/schemas/Pet" }
      end

      def request_description
        '<GRAPHQL_INPUT_DESCRIPTION>'
      end
    end
  end
end
