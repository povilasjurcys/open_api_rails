# frozen_string_literal: true

require 'open_api_rails/schema/adapters/json_api_schema_serializer'
require 'open_api_rails/schema/route'

module OpenApiRails
  # Represents OpenAPI specification
  class Schema
    VERSION = '1.0.0'
    CONTACT_EMAIL = 'admin@samesystem.com'
    TITLE = 'Samesystem - OpenAPI 3.0'
    TAGS = [].freeze

    def initialize(server_urls:, adapter: ::OpenApiRails::Schema::Adapters::JsonApiSchemaSerializer)
      @server_urls = Array(server_urls)
      @adapter = adapter
    end

    def open_api_json
      adapter.new(self).open_api_json
    end

    def tags
      TAGS
    end

    def title
      TITLE
    end

    def contact_email
      CONTACT_EMAIL
    end

    def version
      VERSION
    end

    def servers
      server_urls.map { { url: _1 } }
    end

    def paths
      routes
        .group_by { |route| relative_path(route) }
        .transform_values { |routes| routes.index_by(&:http_method) }
    end

    def routes
      @routes ||= open_api_routes.map { |route| Route.new(route) }.select(&:configured?)
    end

    private

    attr_reader :server_urls, :adapter

    def relative_path(route)
      path = route.path
      matching_server_url = server_urls.detect { path.starts_with?(_1) }
      return path if matching_server_url.blank?

      path.sub(matching_server_url, '/')
    end

    def rails_routes
      Rails.application.routes.routes
    end

    def open_api_routes
      @open_api_routes ||= rails_routes.select { swaggerized_route?(_1) }
    end

    def swaggerized_route?(route)
      server_urls.any? do |prefix|
        route.path.spec.to_s.starts_with?(prefix)
      end
    end
  end
end
