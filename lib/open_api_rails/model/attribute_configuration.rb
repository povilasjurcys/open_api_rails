# frozen_string_literal: true

require 'open_api_rails/attributes/base_attribute_configuration'
require 'open_api_rails/model/attribute_type_parser'

module OpenApiRails
  module Model
    class AttributeConfiguration < OpenApiRails::Attributes::BaseAttributeConfiguration
      def type_parser
        @type_parser ||= ::OpenApiRails::Model::AttributeTypeParser.new(unparsed_type: type)
      end
    end
  end
end
