# frozen_string_literal: true

module OpenApiRails
  class Schema
    module Adapters
      class SimpleSchemaSerializer
        class TransformParameter
          def self.call(**options)
            new(**options).call
          end

          def initialize(parameter:, schema:, **_options)
            @parameter = parameter
            @schema = schema
          end

          def call
            {
              in: location,
              name: name,
              description: description,
              schema: parameter_schema,
              required: required? || type_parser.type_info.required?
            }.compact
          end

          private

          attr_reader :parameter, :schema

          def location
            parameter.location
          end

          def name
            parameter.name
          end

          def description
            parameter.description
          end

          def parameter_schema
            type_parser.open_api_json
          end

          def required?
            parameter.required?
          end

          def basic_type?
            type_info.basic_type?
          end

          def type_info
            type_parser.type_info
          end

          def type_parser
            @type_parser ||= parameter.type_parser
          end
        end
      end
    end
  end
end
