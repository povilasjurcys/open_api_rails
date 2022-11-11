# frozen_string_literal: true

require 'graphql_to_rest/open_api/graphql_input_type_name_parser'

module GraphqlToRest
  module OpenApi
    # Converts GraphQL type to OpenAPI schema
    class GraphqlToComponentsRequestBody
      method_object %i[type! subtype]

      def call
        {
          open_api_type_name => {
            type: 'object',
            properties: properties,
            required: required_properties.presence
          }.compact
        }
      end

      private

      delegate :open_api_type_name, to: :type_parser, private: true

      def properties
        field_parsers.transform_values(&:open_api_schema)
      end

      def required_properties
        field_parsers.select { |_k, v| v.required? }.keys
      end

      def field_parsers
        @field_parsers ||= graphql_object.arguments.transform_values do |argument|
          field_parser_for(argument.type.to_type_signature)
        end
      end

      def field_parser_for(type_name)
        GraphqlInputTypeNameParser.new(graphql_type_name: type_name)
      end

      def graphql_object
        type_parser.inner_nullable_graphql_object
      end

      def type_parser
        @type_parser ||= GraphqlInputTypeNameParser.new(graphql_type_name: type.to_s, subtype: subtype)
      end
    end
  end
end
