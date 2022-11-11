# frozen_string_literal: true

module GraphqlToRest
  module OpenApi
    module Controller
      # Configuration for OpenAPI controller action parameter
      class ParameterConfiguration
        rattr_initialize %i[name!]

        def default_value(value = nil)
          return @default_value if value.nil?

          @default_value = value
          self
        end
      end
    end
  end
end
