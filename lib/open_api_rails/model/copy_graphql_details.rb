# frozen_string_literal: true

module OpenApiRails
  module Model
    # Sets OpenApiRails::Model structure same as GraphqlRails::Model
    class CopyGraphqlDetails
      def self.call(*args)
        new(*args).call
      end

      def initialize(graphql:, open_api_model_config:)
        @open_api = open_api_model_config
        @graphql = graphql
      end

      def call
        copy_graphql_config_to_open_api

        open_api
      end

      private

      attr_reader :graphql, :open_api

      def copy_graphql_config_to_open_api
        open_api.name(graphql.name)

        graphql.attributes.each_value do |attribute|
          copy_graphql_attribute_to_open_api(attribute)
        end
      end

      def copy_graphql_attribute_to_open_api(graphql_attribute)
        open_api_attribute = open_api.attribute(graphql_attribute.field_name)
        open_api_attribute.description(graphql_attribute.description)
        configure_attribute_type(open_api_attribute, graphql_attribute)
      end

      def configure_attribute_type(open_api_attribute, graphql_attribute)
        type = open_api_type_for(graphql_attribute)
        open_api_attribute.type(type)
      end

      def open_api_type_for(graphql_attribute)
        attribute_parser = ::OpenApiRails::Attributes::GraphqlAttributeParser
        attribute_parser.new(graphql_attribute).open_api_type
      end
    end
  end
end
