# frozen_string_literal: true

module GraphqlToRest
  module OpenApi
    # Converts GraphQL type to OpenAPI schema
    class GraphqlInputTypeNameParser < GraphqlTypeNameParser
      rattr_initialize %i[graphql_type_name! subtype]

      private

      def non_list_property
        scalar_type_details || reference_type_details
      end

      def reference_type_details
        {
          '$ref': "#/components/#{reference_type}/#{inner_nullable_type}"
        }
      end

      def reference_type
        inner_nullable_type.ends_with?('Enum') ? 'schemas' : 'requestBodies'
      end

      def fetch_graphql_object
        graphql = inner_nullable_type.constantize
        return graphql unless graphql.respond_to?(:graphql)

        graphql.graphql.input(*subtype).graphql_input_type
      end
    end
  end
end
