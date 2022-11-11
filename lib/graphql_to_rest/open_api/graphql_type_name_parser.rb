# frozen_string_literal: true

module GraphqlToRest
  module OpenApi
    # Converts GraphQL type to OpenAPI schema
    class GraphqlTypeNameParser
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

      SCALAR_TYPE_MAPPING = {
        **BASIC_TYPE_MAPPING,
        'period' => { '$ref': '#/components/schemas/Period' }
      }.freeze

      rattr_initialize %i[graphql_type_name!]

      def open_api_schema
        if list?
          list_property
        else
          non_list_property
        end
      end

      def required?
        graphql_type_name.ends_with?('!')
      end

      def list?
        graphql_type_name.include?(']')
      end

      def open_api_type_name
        basic_type? ? potential_open_api_type_name : open_api_type_name_from_graphql
      end

      def inner_nullable_graphql_object
        return @inner_nullable_graphql_object if defined?(@inner_nullable_graphql_object)

        @inner_nullable_graphql_object = basic_type? ? nil : fetch_graphql_object
      end

      def scalar?
        scalar_type_details.present?
      end

      private

      def basic_type?
        BASIC_TYPE_MAPPING.key?(potential_open_api_type_name)
      end

      def list_property
        items_schema = self.class.new(graphql_type_name: inner_type).open_api_schema
        return {} if items_schema.blank?

        {
          type: 'array',
          items: items_schema
        }
      end

      def non_list_property
        scalar_type_details || {}
      end

      def scalar_type_details
        SCALAR_TYPE_MAPPING[potential_open_api_type_name]
      end

      def inner_type
        graphql_type_name.sub(/\]!?/, '').sub('[', '')
      end

      def inner_nullable_type
        graphql_type_name.sub('!', '')
      end

      def potential_open_api_type_name
        inner_nullable_type.split('::').last.downcase
      end

      def open_api_type_name_from_graphql
        inner_nullable_graphql_object.graphql_name.split('::').last
      end

      def fetch_graphql_object
        graphql_class = inner_nullable_type.constantize
        return graphql_class unless graphql_class.respond_to?(:graphql)

        graphql_class.graphql.graphql_type
      end
    end
  end
end
