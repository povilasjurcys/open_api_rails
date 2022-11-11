# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/string'
require 'active_support/core_ext/enumerable'
require 'attr_extras'
require "graphql_to_rest/version"
require 'graphql_to_rest/open_api'

module GraphqlToRest
  class Error < StandardError; end
end
