# frozen_string_literal: true

module OpenApiRails
  class Schema
    module Adapters
      class SimpleSchemaSerializer
        class TransformArgumentType
          def self.call(**options)
            new(**options).call
          end

          def initialize(type:, schema:, **_options)
            @type = type
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

          attr_reader :type, :schema

          def type_parser
            @type_parser ||= ::OpenApiRails::Controller::ArgumentTypeParser.new(unparsed_type: type)
          end

          def format_open_api_json
            { format: type_format }.compact
          end
        end
      end
    end
  end
end
