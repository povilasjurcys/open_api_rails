# frozen_string_literal: true

module OpenApiRails
  module Controller
    # Parses graphql-style type expression and returns open api type details.
    class ArgumentTypeParser < ::OpenApiRails::Attributes::TypeParser
      attr_reader :graphql_subtype

      def initialize(unparsed_type:, graphql_subtype:)
        super(unparsed_type: unparsed_type)
        @graphql_subtype = graphql_subtype
      end

      def schema_open_api_json
        if basic_type?
          { type: type_info.nullable_inner_name }
        else
          open_api_model_configuration.open_api_json
        end
      end

      def open_api_json
        if basic_type?
          { type: type_info.nullable_inner_name.downcase }
        else
          model_ref_open_api_json
        end
      end

      def nullable_inner_type_name
        open_api_model_configuration.name
      end

      def basic_type?
        type_info.basic_type?
      end

      private

      def model_ref_open_api_json
        { :$ref => "#/components/requestBodies/#{open_api_model_configuration.name}" }
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

      def graphql_model_open_api
        self.class.cached_graphql_classes[type_model.name] ||= build_graphql_model_open_api
      end

      def build_graphql_model_open_api
        config = OpenApiRails::Model::ModelConfiguration.new

        ::OpenApiRails::Model::CopyGraphqlDetails.call(
          graphql: type_model.graphql.input(graphql_subtype),
          open_api_model_config: config
        )
      end
    end
  end
end
