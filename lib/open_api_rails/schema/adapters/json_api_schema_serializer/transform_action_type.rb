# frozen_string_literal: true

module OpenApiRails
  class Schema
    module Adapters
      class JsonApiSchemaSerializer
        class TransformActionType < SimpleSchemaSerializer::TransformActionType
          private

          def type_open_api_json
            unwrapped_json = super
            return if unwrapped_json.blank?

            {
              type: 'object',
              properties: {
                links: type_links,
                meta: type_meta,
                data: unwrapped_json
              },
              required: %w[data]
            }
          end

          def type_links
            {
              type: 'object',
              properties: {
                self: {
                  type: 'string',
                  format: 'uri'
                },
                related: {
                  type: 'string',
                  format: 'uri'
                }
              }
            }
          end

          def type_meta
            {
              type: 'object'
            }
          end
        end
      end
    end
  end
end
