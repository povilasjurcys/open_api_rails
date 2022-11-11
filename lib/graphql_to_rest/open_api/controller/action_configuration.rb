# frozen_string_literal: true

require 'graphql_to_rest/open_api/controller/parameter_configuration'

module GraphqlToRest
  module OpenApi
    module Controller
      # Configuration for OpenAPI controller action
      class ActionConfiguration
        def initialize(controller_config:)
          @controller_config = controller_config
          @query_parameters = {}
          @path_parameters = {}
        end

        def query_parameter(name)
          @query_parameters[name.to_s] ||= ParameterConfiguration.new(name: name.to_s)
          param = @query_parameters[name.to_s]
          yield(param) if block_given?
          param
        end

        def path_parameter(name)
          @path_parameters[name.to_s] ||= ParameterConfiguration.new(name: name.to_s)
        end

        def fieldset_parameter
          @fieldset_parameter ||=
            ParameterConfiguration.new(name: "fields[#{controller_config.model}]")
        end

        def graphql_action(name = nil)
          return @graphql_action if name.nil?

          @graphql_action = name
          self
        end

        def graphql_input_type_path(nesting = nil)
          return @graphql_input_type_path || [] if nesting.nil?

          @graphql_input_type_path = Array(nesting)
          self
        end

        private

        attr_reader :controller_config
      end
    end
  end
end
