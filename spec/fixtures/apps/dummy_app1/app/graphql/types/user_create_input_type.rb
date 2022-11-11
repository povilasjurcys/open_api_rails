# frozen_string_literal: true

require 'graphql'

module GraphqlToRest
  module DummyApp1
    module Types
      class UserCreateInputType < GraphQL::Schema::InputObject
        graphql_name 'UserCreateInputType'

        argument :email, type: String, required: true
        argument :full_name, type: String, required: true
      end
    end
  end
end
