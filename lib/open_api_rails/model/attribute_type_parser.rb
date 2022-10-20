# frozen_string_literal: true

require 'open_api_rails/attributes/type_parser'
require 'open_api_rails/model/model_configuration'
require 'open_api_rails/model/copy_graphql_details'

module OpenApiRails
  module Model
    # Parses graphql-style type expression and returns open api type details.
    class AttributeTypeParser < ::OpenApiRails::Attributes::TypeParser
      def schema_open_api_json
        if basic_type?
          { type: nullable_inner_type_name }
        else
          open_api_model_configuration.open_api_json
        end
      end

      def open_api_json
        if basic_type?
          { type: nullable_inner_type_name }
        else
          model_ref_open_api_json
        end
      end

      def nullable_inner_type_name
        if basic_type?
          type_info.nullable_inner_name.downcase
        else
          open_api_model_configuration.name
        end
      end

      def open_api_model_configuration
        @open_api_model_configuration ||=
          if open_api_inner_type?
            type_model.open_api
          elsif graphql_inner_type?
            graphql_model_open_api
          else
            raise "Unknown type: #{unparsed_type.inspect}"
          end
      end

      private

      def model_ref_open_api_json
        { :$ref => "#/components/schemas/#{open_api_model_configuration.name}" }
      end

      def graphql_model_open_api
        self.class.cached_graphql_classes[type_model.name] ||= build_graphql_model_open_api
      end

      def build_graphql_model_open_api
        config = OpenApiRails::Model::ModelConfiguration.new

        ::OpenApiRails::Model::CopyGraphqlDetails.call(
          graphql: type_model.graphql,
          open_api_model_config: config
        )
      end
    end
  end
end
