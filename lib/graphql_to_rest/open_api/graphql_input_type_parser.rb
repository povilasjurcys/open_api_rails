# frozen_string_literal: true

require 'graphql_to_rest/open_api/graphql_type_parser'

module GraphqlToRest
  module OpenApi
    # Converts GraphQL type to OpenAPI schema
    class GraphqlInputTypeParser < GraphqlTypeParser
      rattr_initialize %i[unparsed_type!]
    end
  end
end
