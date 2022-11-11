# frozen_string_literal: true

module GraphqlToRest
  module OpenApi
    module Paths
      # Converts GraphQL type to OpenAPI path parameters
      class RouteToParameters
        DEFAULT_PARAMETER_OPTIONS = {
          'ctx_token' => {
            example: 'c1d1',
            description: 'Context token'
          }
        }.freeze

        method_object %i[route!]

        def call
          [fieldset_parameter, *path_parameters]
        end

        private

        delegate :action_config, :return_type, to: :route, private: true

        def fieldset_parameter
          RouteToFieldsetParameter.call(route: route)
        end

        def path_parameters
          route.path_parameters.map { path_parameter(_1) }
        end

        def extra_schema_params_for(parameter_name)
          default_params = DEFAULT_PARAMETER_OPTIONS[parameter_name] || {}
          default_value = action_config.path_parameter(parameter_name).default_value
          return default_params if default_value.nil?

          default_params.merge(default: default_value)
        end

        def path_parameter(parameter_name)
          {
            name: parameter_name,
            in: 'path',
            required: true,
            schema: {
              type: 'string',
              **extra_schema_params_for(parameter_name)
            }.compact
          }
        end
      end
    end
  end
end
