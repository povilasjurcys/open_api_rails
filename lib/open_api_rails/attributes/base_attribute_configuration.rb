# frozen_string_literal: true

require 'open_api_rails/concerns/chainable_getter_setter'
require 'open_api_rails/concerns/type_configurable'

module OpenApiRails
  module Attributes
    class BaseAttributeConfiguration
      include ::OpenApiRails::ChainableGetterSetter
      include ::OpenApiRails::TypeConfigurable

      chainable_getter_setter :description
      chainable_getter_setter :type_format
      chainable_getter_setter :default_value

      attr_reader :name

      def initialize(name)
        @name = name
      end

      def required
        @required = true
      end

      def optional
        @required = false
      end

      def required?
        return @required if @required != nil

        type_name_info.required?
      end

      def open_api_json
        {
          **type_open_api_json,
          **format_open_api_json,
          **description_open_api_json
        }
      end

      def configured?
        type.present?
      end

      def open_api_type
        type_format(type)
      end

      def basic_type?
        type_name_info.basic_type?
      end

      private

      def description_open_api_json
        { description: description.presence }.compact
      end
    end
  end
end
