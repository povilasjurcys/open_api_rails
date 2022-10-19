# frozen_string_literal: true

module OpenApiRails
  class Schema
    module Adapters
      class SimpleSchemaSerializer
        class TransformComponents
          def self.call(**options)
            new(**options).call
          end

          def initialize(schema:, **_options)
            @schema = schema
          end

          def call
            {
              schemas: schemas,
              requestBodies: request_bodies,
              securitySchemes: schema.security_schemes
            }
          end

          private

          attr_reader :schema

          def routes
            schema.routes
          end

          def schemas
            routes.map(&:component_schema).reduce(:merge)
          end

          def request_bodies
            routes.map(&:request_body_schemas).reduce(:merge)
          end

          def security_schemes
            {
              bearerAuth: {
                type: 'http',
                scheme: 'bearer',
                bearerFormat: 'JWT'
              }
            }
          end
        end
      end
    end
  end
end
