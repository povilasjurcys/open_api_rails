# frozen_string_literal: true

module GraphqlToRest
  module OpenApi
    # Converts GraphQL type to OpenAPI schema
    class GraphqlTypeParser
      BASIC_TYPE_MAPPING = {
        'id' => { type: 'string' },
        'string' => { type: 'string' },
        'text' => { type: 'string' },
        'integer' => { type: 'integer', format: 'int64' },
        'boolean' => { type: 'boolean' },
        'float' => { type: 'number', format: 'float' },
        'decimal' => { type: 'number', format: 'double' },
        'iso8601date' => { type: 'string', format: 'date' },
        'date' => { type: 'string', format: 'date' },
        'datetime' => { type: 'string', format: 'date-time' },
        'time' => { type: 'string', format: 'time' }
      }.freeze

      rattr_initialize %i[unparsed_type!]

      def open_api_type_name
        basic_type_name || graphql_name
      end

      def inner_nullable_graphql_object
        unwrap_type(unparsed_type)
      end

      def scalar?
        inner_nullable_graphql_object < GraphQL::Schema::Scalar
      end

      private

      delegate :graphql_name, to: :inner_nullable_graphql_object

      def basic_type_schema
        BASIC_TYPE_MAPPING[graphql_name.downcase]
      end

      def basic_type_name
        graphql_name.downcase if basic_type_schema
      end

      def unwrap_type(unwraped_type)
        if unwraped_type.is_a?(GraphQL::Schema::Wrapper)
          unwrap_type(unwraped_type.of_type)
        else
          unwraped_type
        end
      end
    end
  end
end
