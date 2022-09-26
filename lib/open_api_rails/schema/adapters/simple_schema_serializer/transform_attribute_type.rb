# frozen_string_literal: true

module OpenApiRails
  class Schema
    module Adapters
      class SimpleSchemaSerializer
        class TransformAttributeType
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
              **type_parser.open_api_json,
              **format_open_api_json
            }
          end

          private

          delegate :type, to: :action

          attr_reader :action, :schema

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
