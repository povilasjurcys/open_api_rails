# frozen_string_literal: true

require 'graphql_to_rest/open_api/paths'
require 'graphql_to_rest/open_api/graphql_to_components_schema'
require 'graphql_to_rest/open_api/graphql_to_components_request_body'

module GraphqlToRest
  module OpenApi
    # openapi.json file generator
    class Schema
      OPENAPI_VERSION = '3.0.2'

      attr_reader :tags, :servers, :info, :security_schemes

      def initialize(tags:, servers:, info:, security_schemes:)
        @tags = tags
        @servers = servers
        @info = info
        @security_schemes = security_schemes
      end

      def as_json
        {
          **general_info,
          paths: paths,
          components: {
            schemas: components_schemas,
            securitySchemes: security_schemes,
            requestBodies: components_request_bodies
          }
        }
      end

      def paths
        rails_api_routes
          .map { |rails_route| Paths::RouteDecorator.new(rails_route: rails_route) }
          .map { |decorated_route| Paths::RouteToPathSchema.call(route: decorated_route) }
          .reduce(:deep_merge)
      end

      def general_info
        {
          openapi: OPENAPI_VERSION,
          info: info,
          servers: servers,
          tags: tags,
          security: security
        }
      end

      def security
        security_schemes.keys.map { |key| { key => [] } }
      end

      def components_schemas
        {
          **components_schema_for(::Graphql::Users::UserDecorator),
          **components_schema_for(::Graphql::Authentication::UserSessionDecorator),
          **components_schema_for(::Types::CountryEnum),
          **components_schema_for(::Types::CivilStateEnum),
          **components_schema_for(::Types::GenderEnum),
          **components_schema_for(::Types::Period)
        }
      end

      def components_request_bodies
        {
          **components_request_body_for(::Graphql::Users::CreateUser),
          **components_request_body_for(Types::SignInUser::AuthProviderInput),
          **components_request_body_for(Types::ExtraFieldInputType)
        }
      end

      private

      def server_urls
        @server_urls ||= servers.map { _1[:url] }
      end

      def rails_api_routes
        Rails.application.routes.routes.select do |route|
          route_url = route.path.spec.to_s
          server_urls.any? { |prefix| route_url.start_with?(prefix) }
        end
      end

      def components_schema_for(type)
        GraphqlToComponentsSchema.call(type: type)
      end

      def components_request_body_for(graphql_input_class, subtype: nil)
        GraphqlToComponentsRequestBody.call(type: graphql_input_class, subtype: subtype)
      end
    end
  end
end
