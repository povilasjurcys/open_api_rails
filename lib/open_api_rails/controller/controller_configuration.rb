# frozen_string_literal: true

require 'open_api_rails/controller/action_configuration'

module OpenApiRails
  module Controller
    # Stores action configuration for OpenAPI controller
    class ControllerConfiguration
      attr_reader :actions

      def initialize
        @actions = {}
      end

      def action(name)
        action_name = name.to_sym
        @actions[action_name] ||= build_action_configuration(action_name)
        @actions[action_name].tap { yield(_1) if block_given? }
      end

      private

      def build_action_configuration(action_name)
        ::OpenApiRails::Controller::ActionConfiguration.new(action_name)
      end
    end
  end
end
