# frozen_string_literal: true

module OpenApiRails
  module Attributes
    # Parses GraphqlRails::Attribute and returns various info related to it.
    class GraphqlAttributeParser
      TYPES_MAP = {
        'GraphQL::Types::ISO8601Date' => 'date',
        'GraphQL::Types::ISO8601DateTime' => 'date-time',
        'ID' => 'string'
      }

      attr_reader :graphql_attribute

      def initialize(graphql_attribute)
        @graphql_attribute = graphql_attribute
      end

      def open_api_type
        return nullable_type.downcase if basic_type?

        type_to_use = TYPES_MAP[nullable_type] || nullable_type
        graphql_type.sub(nullable_type, type_to_use)
      end

      def basic_type?
        type_name_info.basic_type?
      end

      private

      def nullable_type
        @nullable_type ||= type_name_info.nullable_inner_name
      end

      def type_name_info
        @type_name_info ||= OpenApiRails::Attributes::TypeNameInfo.new(graphql_type)
      end

      def graphql_type
        @graphql_type ||= fetch_graphql_type
      end

      def raw_graphql_type
        return @raw_graphql_type if defined?(@raw_graphql_type)

        @raw_graphql_type = graphql_attribute.type
      end

      def fetch_graphql_type
        return raw_graphql_type.to_s if raw_graphql_type
        return 'ID!' if id_type_name?
        return 'Boolean!' if boolean_type_name?

        'String'
      end

      def id_type_name?
        graphql_attribute_name == 'id' || graphql_attribute_name.ends_with?('id')
      end

      def boolean_type_name?
        graphql_attribute_name.ends_with?('?')
      end

      def graphql_attribute_name
        @graphql_attribute_name ||= graphql_attribute.name.to_s.underscore
      end
    end
  end
end
