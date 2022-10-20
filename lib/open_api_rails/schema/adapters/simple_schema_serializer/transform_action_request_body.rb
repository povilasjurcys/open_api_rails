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
            require 'pry'; binding.pry
            return properties if flatten_properties?

            {
              type: 'object',
              properties: properties,
              required: required
            }
          end

          def properties
            @properties ||= build_properties_json
          end

          def build_properties_json
            request_body_arguments.map(&:property_schema_json).reduce(:merge) || {}
          end

          def required
            request_body_arguments.reject(&:flatten?).select(&:required?).map(&:name).presence
          end

          def flatten_properties?
            request_body_arguments.all?(&:flatten?)
          end
        end
      end
    end
  end
end
