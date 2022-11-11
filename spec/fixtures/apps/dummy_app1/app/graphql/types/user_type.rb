# frozen_string_literal: true

require 'graphql'

module GraphqlToRest
  module DummyApp1
    module Types
      class UserType < GraphQL::Schema::Object
        description "The query root of this schema"

        field :id, ID, 'User ID', null: false
        field :email, String, 'User email', null: false
        field :full_name, String, 'User full name', null: false
      end
    end
  end
end
