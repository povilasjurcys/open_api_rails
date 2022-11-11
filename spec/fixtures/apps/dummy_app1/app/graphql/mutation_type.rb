# frozen_string_literal: true

require_relative 'types/user_type'
require_relative 'types/user_create_input_type'

module GraphqlToRest
  module DummyApp1
    class MutationType < GraphQL::Schema::Object
      description "The mutation root of this schema"

      field :create_user, Types::UserType, "Create a user" do
        argument :input, Types::UserCreateInputType, required: true
      end

      def create_user(input:)
        OpenStruct.new(input)
      end
    end
  end
end
