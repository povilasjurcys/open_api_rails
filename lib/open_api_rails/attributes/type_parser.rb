# frozen_string_literal: true

require 'open_api_rails/attributes/type_name_info'

module OpenApiRails
  module Attributes
    # Parses graphql-style type expression and returns open api type details.
    class TypeParser
      BASIC_TYPES = %w[string integer number boolean].freeze

      attr_reader :unparsed_type

      def self.cached_graphql_classes
        @cached_graphql_classes ||= {}
      end

      def initialize(unparsed_type:)
        @unparsed_type = unparsed_type
      end

      def type_info
        @type_info ||= OpenApiRails::Attributes::TypeNameInfo.new(unparsed_type)
      end

      private

      def basic_type?
        type_info.basic_type?
      end

      def open_api_inner_type?
        type_model.respond_to?(:open_api)
      end

      def graphql_inner_type?
        type_model.respond_to?(:graphql)
      end

      def type_model
        return @type_model if defined?(@type_model)

        @type_model = type_info.nullable_inner_name.safe_constantize
      end
    end
  end
end
