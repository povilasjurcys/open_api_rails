# frozen_string_literal: true

require 'open_api_rails/controller/argument_type_parser'

module OpenApiRails
  module Controller
    class ArgumentConfiguration < OpenApiRails::Attributes::BaseAttributeConfiguration
      chainable_getter_setter :location

      def in_path?
        location == :path
      end

      def in_header?
        location == :header
      end

      def in_query?
        location == :query
      end

      def in_request_body?
        location == :request_body
      end

      def in_path
        location(:path)
      end

      def in_header
        location(:header)
      end

      def in_query
        location(:query)
      end

      def in_request_body
        location(:request_body)
      end

      def configured?
        super && location.present?
      end

      def graphql_subtype(value = nil)
        return @graphql_subtype if value.nil?

        @type_parser = nil
        @graphql_subtype = value
        self
      end

      def parameter_open_api_json
        {
          in: location,
          name: name,
          description: description,
          schema: schema,
          required: required? || type_parser.type_info.required?
        }.compact
      end

      def schema
        type_parser.open_api_json
      end

      def request_body_schema
        return {} if type_parser.basic_type?

        {
          type_parser.nullable_inner_type_name => type_parser.schema_open_api_json
        }
      end

      def type_parser
        @type_parser ||= ::OpenApiRails::Controller::ArgumentTypeParser.new(
          unparsed_type: type,
          graphql_subtype: graphql_subtype
        )
      end
    end
  end
end
