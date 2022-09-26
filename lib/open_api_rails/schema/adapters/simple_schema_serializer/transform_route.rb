# frozen_string_literal: true

module OpenApiRails
  class Schema
    module Adapters
      class SimpleSchemaSerializer
        class TransformRoute
          def self.call(**options)
            new(**options).call
          end

          def initialize(route:, schema:, **_options)
            @route = route
            @schema = schema
          end

          def call
            schema.transform_action.call(action: route.action, schema: schema)
          end

          private

          attr_reader :route, :schema
        end
      end
    end
  end
end
