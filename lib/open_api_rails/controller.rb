# frozen_string_literal: true

require 'open_api_rails/controller/controller_configuration'

module OpenApiRails
  # Allows defining actions for OpenAPI controller
  module Controller
    # Class methods
    module ClassMethods
      def open_api
        @open_api ||= ::OpenApiRails::Controller::ControllerConfiguration.new
        @open_api.tap { yield(_1) if block_given? }
      end
    end

    def self.included(base)
      base.extend ClassMethods
    end

    protected

    def open_api
      self.class.open_api
    end

    def open_api_action
      open_api.action(action_name)
    end
  end
end
