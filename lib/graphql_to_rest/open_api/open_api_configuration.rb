# frozen_string_literal: true

module GraphqlToRest
  module OpenApi
    # Configuration for OpenAPI
    class OpenApiConfiguration
      def path_schemas_dir(path = nil)
        return @path_schemas_dir || default_path_schemas_dir if path.nil?

        @path_schemas_dir = path.is_a?(String) ? Pathname.new(path) : path
        self
      end

      def graphql_schema(schema = nil)
        return @graphql_schema if schema.nil?

        @graphql_schema = schema
        self
      end

      private

      def default_path_schemas_dir
        Rails.root.join('app/open_api/path_schemas')
      end
    end
  end
end
