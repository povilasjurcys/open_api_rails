# frozen_string_literal: true

module OpenApiRails
  class Schema
    module Adapters
      class SimpleSchemaSerializer
        class TransformActionType
          def self.call(**options)
            new(**options).call
          end

          def initialize(action:, schema:, **_options)
            @action = action
            @schema = schema
          end

          def call
            return {} if type.blank?

            {
              **type_open_api_json,
              **format_open_api_json
            }
          end

          private

          attr_reader :action, :schema

          def type_open_api_json
            type_parser.open_api_json
          end

          def type
            action.type
          end

          def type_format
            action.type_format
          end

          def type_parser
            @type_parser ||= ::OpenApiRails::Model::AttributeTypeParser.new(unparsed_type: type)
          end

          def format_open_api_json
            { format: type_format }.compact
          end
        end
      end
    end
  end
end
