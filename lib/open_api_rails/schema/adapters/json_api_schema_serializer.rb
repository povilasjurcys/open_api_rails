# frozen_string_literal: true

require 'open_api_rails/schema/adapters/simple_schema_serializer'

module OpenApiRails
  class Schema
    module Adapters
      class JsonApiSchemaSerializer < SimpleSchemaSerializer
        def initialize(schema)
          super(schema)
          self.transform_action_request_body = JsonApiSchemaSerializer::TransformActionRequestBody
        end
      end
    end
  end
end
