# frozen_string_literal: true

module OpenApiRails
  class Schema
    module Adapters
      class JsonApiSchemaSerializer
        class TransformParameter < SimpleSchemaSerializer::TransformParameter
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
              style: parameter.style,
              explode: parameter.explode,
              required: required? || type_info.required?
            }.compact
          end

          private

          attr_reader :parameter, :schema

          def parameter_schema
            if basic_type?
              basic_type_parameter_schema_for(parameter)
            else
              super
            end
          end

          def basic_type_parameter_schema_for(parameter)
            return {} unless parameter

            open_api_type = parameter.type_info.nullable_inner_name.downcase
            items_json = open_api_type == 'array' ? items_json_for(parameter) : {}
            properties_json = open_api_type == 'object' ? properties_json_for(parameter) : {}

            {
              enum: parameter.enum,
              example: parameter.example.presence,
              description: parameter.description.presence,
              **items_json,
              **properties_json,
              type: open_api_type
            }.compact
          end

          def transform_attribute(attribute)
            {
              type: attribute.type_info.nullable_inner_name.downcase,

            }
          end

          def properties_json_for(parameter)
            additional_properties = parameter.additional_properties
            properties_json = parameter.properties.transform_values { basic_type_parameter_schema_for(_1) }
            additional_properties_json = additional_properties.is_a?(String) ? { type: additional_properties } : additional_properties

            {
              properties: properties_json.presence,
              additionalProperties: additional_properties_json
            }.compact
          end

          def items_json_for(parameter)
            { items: basic_type_parameter_schema_for(parameter.items) }
          end
        end
      end
    end
  end
end
