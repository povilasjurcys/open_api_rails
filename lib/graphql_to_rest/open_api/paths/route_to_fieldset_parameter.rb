# frozen_string_literal: true

module GraphqlToRest
  module OpenApi
    module Paths
      # Extracts OpenAPI query fieldset parameter from route
      class RouteToFieldsetParameter
        DESCRIPTION = 'Comma separated list of #/components/schemas/%<type>s fields that must be returned'

        FIELDSET_BASIC_SPECS = {
          in: 'query',
          style: 'simple',
          explode: false,
          required: false
        }.freeze

        method_object %i[route!]

        def call
          {
            **FIELDSET_BASIC_SPECS,
            name: parameter_name,
            description: description,
            schema: schema
          }
        end

        private

        delegate :open_api_type_name, to: :type_parser, private: true
        delegate :action_config, :return_type, to: :route, private: true

        def parameter_name
          "fields[#{open_api_type_name}]"
        end

        def description
          format(DESCRIPTION, type: open_api_type_name)
        end

        def schema
          {
            items: {
              type: 'string',
              enum: fieldset_enum
            },
            type: 'array',
            **default_value_params,
            **extra_params
          }
        end

        def fieldset_enum
          type_parsers.select { |_, parser| parser.scalar? }.keys.sort
        end

        def type_parsers
          @type_parsers ||= graphql_object.fields.transform_values do |field|
            GraphqlTypeParser.new(unparsed_type: field.type)
          end
        end

        def extra_params
          RouteToParameters::DEFAULT_PARAMETER_OPTIONS[parameter_name] || {}
        end

        def default_value_params
          default_value = action_config.fieldset_parameter.default_value
          return {} if default_value.nil?

          { default: default_value.join(',') }
        end

        def graphql_object
          type_parser.inner_nullable_graphql_object
        end

        def type_parser
          @type_parser ||= GraphqlTypeParser.new(unparsed_type: return_type)
        end
      end
    end
  end
end
