# frozen_string_literal: true

module OpenApiRails
  class Schema
    module Adapters
      class SimpleSchemaSerializer
        # Transforms action request body arguments to OpenAPI JSON.
        class TransformActionRequestBody
          def self.call(**options)
            new(**options).call
          end

          def initialize(action:, schema:, **_options)
            @action = action
            @schema = schema
          end

          def call
            request_body_arguments.empty? ? {} : request_body_json
          end

          private

          attr_reader :action, :schema

          def request_body_arguments
            action.request_body_arguments
          end

          def request_body_json
            {
              content: {
                'application/json': {
                  schema: request_body_schema.compact
                }
              }
            }
          end

          def request_body_schema
            {
              type: 'object',
              properties: properties,
              required: required
            }
          end

          def properties
            request_body_arguments.index_by(&:name).transform_values(&:schema)
          end

          def required
            request_body_arguments.select(&:required?).map(&:name).presence
          end
        end
      end
    end
  end
end
