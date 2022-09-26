# frozen_string_literal: true

module OpenApiRails
  module Attributes
    # Parses graphql-style type expression and returns various info related to it.
    # Copy-pasted from GraphqlRails::Attributes::TypeNameInfo.
    class TypeNameInfo
      BASIC_TYPES = %w[string integer number boolean].freeze

      attr_reader :name

      def initialize(name)
        @name = name
      end

      def basic_type?
        BASIC_TYPES.include?(nullable_inner_name.downcase)
      end

      def nullable_inner_name
        inner_name[/[^!]+/]
      end

      def inner_name
        name[/[^!\[\]]+!?/]
      end

      def required_inner_type?
        inner_name.include?('!')
      end

      def list?
        name.include?(']')
      end

      def required?
        name.end_with?('!')
      end

      def required_list?
        required? && list?
      end
    end
  end
end
