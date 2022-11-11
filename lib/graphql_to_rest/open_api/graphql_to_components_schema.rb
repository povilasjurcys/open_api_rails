# frozen_string_literal: true

require 'graphql_to_rest/open_api/graphql_type_name_parser'

module GraphqlToRest
  module OpenApi
    # Converts GraphQL type to OpenAPI schema
    class GraphqlToComponentsSchema
      method_object %i[type!]

      def call
        if type < GraphQL::Schema::Enum
          components_schema_for_graphql_enum
        else
          components_schema_for_graphql_object
        end
      end

      private

      delegate :open_api_type_name, to: :type_parser, private: true

      def graphql_object
        type_parser.inner_nullable_graphql_object
      end

      def components_schema_for_graphql_enum
        {
          open_api_type_name => {
            type: 'string',
            enum: type.values.keys
          }
        }
      end

      def components_schema_for_graphql_object
        {
          open_api_type_name => {
            type: 'object',
            properties: properties,
            required: required_properties.presence
          }.compact
        }
      end

      def properties
        field_parsers.transform_values { _1.open_api_schema.presence }.compact
      end

      def required_properties
        field_parsers.select { |_k, v| v.required? }.keys
      end

      def field_parsers
        @field_parsers ||= graphql_object.fields.transform_values do |field|
          field_parser_for(field.type.to_type_signature)
        end
      end

      def field_parser_for(type_name)
        GraphqlTypeNameParser.new(graphql_type_name: type_name)
      end

      def type_parser
        @type_parser ||= GraphqlTypeNameParser.new(graphql_type_name: type.to_s)
      end
    end
  end
end
