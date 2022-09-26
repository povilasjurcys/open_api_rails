# frozen_string_literal: true

module OpenApiRails
  class Schema
    module Adapters
      class SimpleSchemaSerializer
        # Transforms action configuration to OpenAPI JSON.
        class TransformAction
          def self.call(**options)
            new(**options).call
          end

          def initialize(action:, schema:, **_options)
            @action = action
            @schema = schema
          end

          def call
            {
              summary: summary,
              tags: tags,
              parameters: parameters,
              requestBody: request_body,
              responses: responses
            }.transform_values(&:presence).compact
          end

          private

          delegate :parameter_arguments, :tags, :summary, to: :action, private: true

          attr_reader :action, :schema

          def responses
            schema.transform_responses.call({ action: action, schema: schema })
          end

          def request_body
            schema.transform_action_request_body.call(action: action, schema: schema)
          end

          def parameters
            parameter_arguments.map { transform_parameter(_1) }
          end

          def transform_parameter(parameter)
            schema.transform_parameter.call(parameter: parameter, schema: schema)
          end
        end
      end
    end
  end
end
