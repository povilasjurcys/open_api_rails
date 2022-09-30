# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/string'
require 'active_support/core_ext/enumerable'
require "open_api_rails/version"
require 'open_api_rails/schema'
require 'open_api_rails/model'
require 'open_api_rails/controller'

module OpenApiRails
  class Error < StandardError; end
end
