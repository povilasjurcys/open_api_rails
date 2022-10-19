# frozen_string_literal: true

require 'open_api_rails/schema/adapters/json_api_schema_serializer'
require 'open_api_rails/schema/route'

module OpenApiRails
  # Represents OpenAPI specification
  class Schema
    attr_reader :version, :title, :tags, :contact_email, :security_schemes

    def initialize(
      server_urls:,
      title:,
      contact_email:,
      tags: [],
      version: '1.0.0',
      security_schemes: {},
      adapter: ::OpenApiRails::Schema::Adapters::JsonApiSchemaSerializer
    )
      @server_urls = Array(server_urls)
      @adapter = adapter
      @version = version
      @title = title
      @tags = tags
      @contact_email = contact_email
      @security_schemes = security_schemes
    end

    def open_api_json
      adapter.new(self).open_api_json
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
      if !defined?(@routes)
        require 'pry'; binding.pry
      end
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
