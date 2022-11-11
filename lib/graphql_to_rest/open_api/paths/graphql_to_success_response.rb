# frozen_string_literal: true

require 'graphql_to_rest/open_api/graphql_type_parser'

module GraphqlToRest
  module OpenApi
    module Paths
      # Converts GraphQL type to OpenAPI response specification
      class GraphqlToSuccessResponse
        RESPONSE_BASIC_PROPERTIES = {
          links: {
            type: 'object',
            properties: {
              self: {
                type: 'string',
                format: 'uri'
              },
              related: {
                type: 'string',
                format: 'uri'
              }
            }
          },
          meta: {
            type: 'object',
            additionalProperties: true
          }
        }.freeze

        method_object %i[type!]

        def call
          {
            '200': {
              content: {
                'application/json': {
                  schema: schema
                }
              }
            }
          }
        end

        private

        delegate :open_api_type_name, to: :type_parser, private: true

        def schema
          {
            type: 'object',
            properties: {
              **RESPONSE_BASIC_PROPERTIES,
              data: data
            },
            required: %w[data]
          }
        end

        def data
          {
            type: 'object',
            properties: {
              attributes: attributes
            },
            required: %w[attributes]
          }
        end

        def attributes
          { '$ref': "#/components/schemas/#{open_api_type_name}" }
        end

        def type_parser
          @type_parser ||= GraphqlTypeParser.new(unparsed_type: type)
        end
      end
    end
  end
end
