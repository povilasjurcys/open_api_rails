# frozen_string_literal: true

require 'open_api_rails/model/model_configuration'

module OpenApiRails
  # Allows to set Open API component details on class level
  module Model
    # Class methods
    module ClassMethods
      def open_api
        @open_api ||= ::OpenApiRails::Model::ModelConfiguration.new
        @open_api.tap { yield(_1) if block_given? }
      end
    end

    def self.included(base)
      base.extend ClassMethods
    end
  end
end
