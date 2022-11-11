# frozen_string_literal: true

require_relative 'types/user_type'

module GraphqlToRest
  module DummyApp1
    class QueryType < GraphQL::Schema::Object
      description "The query root of this schema"

      field :user, Types::UserType, "Find a User by ID" do
        argument :id, ID
      end

      def user(id:)
        OpenStruct.new(id: id, email: 'john.doe@example.com', full_name: 'John Doe')
      end
    end
  end
end
