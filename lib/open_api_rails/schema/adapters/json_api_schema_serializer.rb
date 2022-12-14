# frozen_string_literal: true

require 'open_api_rails/schema/adapters/simple_schema_serializer'

module OpenApiRails
  class Schema
    module Adapters
      class JsonApiSchemaSerializer < SimpleSchemaSerializer
        require 'open_api_rails/schema/adapters/json_api_schema_serializer/transform_action_type'
        require 'open_api_rails/schema/adapters/json_api_schema_serializer/transform_action_request_body'

        def initialize(schema)
          super(schema)
          self.transform_action_request_body = JsonApiSchemaSerializer::TransformActionRequestBody
          self.transform_action_type = JsonApiSchemaSerializer::TransformActionType
        end
      end
    end
  end
end
