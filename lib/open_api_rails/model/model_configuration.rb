# frozen_string_literal: true

require 'open_api_rails/model/attribute_configuration'
require 'open_api_rails/model/copy_graphql_details'
require 'open_api_rails/concerns/chainable_getter_setter'

module OpenApiRails
  module Model
    # Stores model configuration for OpenAPI model
    class ModelConfiguration
      include ::OpenApiRails::ChainableGetterSetter

      chainable_getter_setter :name

      attr_reader :attributes

      def initialize
        @attributes = {}
      end

      def same_as_graphql(graphql_model)
        copy_params = { graphql: graphql_model.graphql, open_api_model_config: self }
        OpenApiRails::Model::CopyGraphqlDetails.call(copy_params)
      end

      def attribute(name)
        @attributes ||= {}
        @attributes[name] ||= ::OpenApiRails::Model::AttributeConfiguration.new(name)
        @attributes[name].tap { yield(_1) if block_given? }
      end

      def open_api_json
        {
          type: 'object',
          **open_api_properties_json,
          **open_api_required_json
        }
      end

      private

      def open_api_properties_json
        properties = attributes.values.select(&:basic_type?).index_by(&:name).transform_values(&:open_api_json)
        return {} if properties.empty?

        { properties: properties.sort.to_h }
      end

      def open_api_required_json
        required_properties = attributes.values.select(&:required?).map(&:name)
        return {} if required_properties.empty?

        { required: required_properties.sort }
      end
    end
  end
end
