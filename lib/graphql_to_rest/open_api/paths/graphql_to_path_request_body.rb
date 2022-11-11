# frozen_string_literal: true

require 'graphql_to_rest/open_api/graphql_input_type_parser'

module GraphqlToRest
  module OpenApi
    module Paths
      # Converts GraphQL type to request body used in OpenAPI paths part
      class GraphqlToPathRequestBody
        method_object [:graphql_input!, { extra_specs: {} }]

        def call
          {
            'content' => {
              'application/json' => {
                'schema' => request_body_schema,
                **extra_specs
              }
            }
          }
        end

        private

        delegate :open_api_type_name, to: :type_parser, private: true

        def input_object
          type_parser.inner_nullable_graphql_object
        end

        def request_body_schema
          {
            type: 'object',
            properties: request_body_data_properties,
            required: %w[data]
          }
        end

        def attributes_reference
          { '$ref': "#/components/requestBodies/#{open_api_type_name}" }
        end

        def request_body_data_properties
          {
            data: {
              type: 'object',
              properties: {
                attributes: attributes_reference
              },
              required: %w[attributes]
            }
          }
        end

        def type_parser
          @type_parser ||= GraphqlInputTypeParser.new(unparsed_type: graphql_input)
        end
      end
    end
  end
end
