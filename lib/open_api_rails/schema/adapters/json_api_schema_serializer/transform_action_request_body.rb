# frozen_string_literal: true

module OpenApiRails
  class Schema
    module Adapters
      class JsonApiSchemaSerializer
        # Transforms action request body arguments to OpenAPI JSON according to JSON:API specs.
        class TransformActionRequestBody < SimpleSchemaSerializer::TransformActionRequestBody
          private

          def request_body_json
            binding.pry
            {
              content: {
                'application/json': {
                  schema: json_api_request_body_schema
                }
              }
            }
          end

          def json_api_request_body_schema
            {
              type: 'object',
              properties: { data: json_api_data },
              required: %w[data]
            }
          end

          def json_api_attributes
            {
              type: 'object',
              properties: json_api_attribute_properties,
              required: required
            }
          end

          def json_api_attribute_properties
            initial_properties = properties
            initial_properties.keys == ['input'] ? initial_properties['input'] : initial_properties
          end

          def json_api_relationships
            {}
          end

          def json_api_data
            {
              type: 'object',
              properties: json_api_data_properties,
              required: %w[attributes]
            }
          end

          def json_api_data_properties
            {
              attributes: json_api_attributes,
              relationships: json_api_relationships
            }.transform_values(&:presence).compact
          end
        end
      end
    end
  end
end
