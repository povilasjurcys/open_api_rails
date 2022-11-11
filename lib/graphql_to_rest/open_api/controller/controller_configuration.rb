# frozen_string_literal: true

require 'graphql_to_rest/open_api/controller/action_configuration'

module GraphqlToRest
  module OpenApi
    module Controller
      # Configuration for OpenAPI controller
      class ControllerConfiguration
        def initialize
          @actions = {}
        end

        def model(name = nil)
          return @model if name.nil?

          @model = name
          self
        end

        def action(name)
          @actions[name.to_sym] ||= ActionConfiguration.new(controller_config: self)

          config = @actions[name.to_sym]
          yield(config) if block_given?
          config
        end
      end
    end
  end
end
