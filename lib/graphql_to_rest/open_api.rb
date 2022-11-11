# frozen_string_literal: true


require 'graphql_to_rest/open_api/schema'
require 'graphql_to_rest/open_api/controller'
require 'graphql_to_rest/open_api/open_api_configuration'


module GraphqlToRest
  module OpenApi
    def self.configure
      yield(configuration)
    end

    def self.configuration
      @configuration ||= OpenApiConfiguration.new
    end

    def self.with_configuration(configuration)
      old_configuration = @configuration
      @configuration = configuration
      yield
    ensure
      @configuration = old_configuration
    end
  end
end
