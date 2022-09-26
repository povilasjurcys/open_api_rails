# frozen_string_literal: true

require 'open_api_rails/schema/adapters/simple_schema_serializer/transform_route'
require 'open_api_rails/schema/adapters/simple_schema_serializer/transform_parameter'
require 'open_api_rails/schema/adapters/simple_schema_serializer/transform_action'
require 'open_api_rails/schema/adapters/simple_schema_serializer/transform_action_type'
require 'open_api_rails/schema/adapters/simple_schema_serializer/transform_attribute_type'
require 'open_api_rails/schema/adapters/simple_schema_serializer/transform_argument_type'
require 'open_api_rails/schema/adapters/simple_schema_serializer/transform_components'
require 'open_api_rails/schema/adapters/simple_schema_serializer/transform_action_request_body'
require 'open_api_rails/schema/adapters/simple_schema_serializer/transform_responses'

module OpenApiRails
  class Schema
    module Adapters
      class SimpleSchemaSerializer
        OPEN_API_VERSION = '3.0.2'

        attr_accessor :transform_route, :transform_parameter, :transform_action,
                      :transform_action_type, :transform_attribute_type, :transform_argument_type,
                      :transform_components, :transform_action_request_body, :transform_responses

        attr_reader :schema

        def initialize(schema)
          @schema = schema

          self.transform_route = SimpleSchemaSerializer::TransformRoute
          self.transform_parameter = SimpleSchemaSerializer::TransformParameter
          self.transform_action = SimpleSchemaSerializer::TransformAction
          self.transform_action_type = SimpleSchemaSerializer::TransformActionType
          self.transform_attribute_type = SimpleSchemaSerializer::TransformAttributeType
          self.transform_argument_type = SimpleSchemaSerializer::TransformArgumentType
          self.transform_components = SimpleSchemaSerializer::TransformComponents
          self.transform_action_request_body = SimpleSchemaSerializer::TransformActionRequestBody
          self.transform_responses = SimpleSchemaSerializer::TransformResponses
        end

        def open_api_json
          {
            openapi: openapi,
            info: info,
            servers: servers,
            tags: tags,
            paths: paths,
            components: components
          }
        end

        def openapi
          OPEN_API_VERSION
        end

        def tags
          schema.tags
        end

        def servers
          schema.servers
        end

        def components
          transform_components.call(schema: self)
        end

        def info
          {
            title: schema.title,
            contact: { email: schema.contact_email },
            version: schema.version
          }
        end

        def paths
          schema.paths.transform_values do |routes_by_http_method|
            routes_by_http_method.transform_values { transform_route.call(route: _1, schema: self) }
          end
        end

        private

        def routes
          schema.routes
        end
      end
    end
  end
end
