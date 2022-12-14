# frozen_string_literal: true

module OpenApiRails
  class Schema
    module Adapters
      class SimpleSchemaSerializer
        class TransformResponses
          def self.call(**options)
            new(**options).call
          end

          def initialize(action:, schema:, **_options)
            @action = action
            @schema = schema
          end

          def call
            {
              success_status_code.to_s => success_response.presence
            }.compact
          end

          private

          attr_reader :action, :schema

          def success_status_code
            action.success_status_code
          end

          def description
            action.description
          end

          def type
            action.type
          end

          def success_response
            return {} if type.blank?

            {
              description: description,
              content: content
            }.compact
          end

          def content
            {
              'application/json': {
                schema: response_schema
              }
            }
          end

          def response_schema
            schema.transform_action_type.call({ action: action, type: type, schema: schema })
          end
        end
      end
    end
  end
end
