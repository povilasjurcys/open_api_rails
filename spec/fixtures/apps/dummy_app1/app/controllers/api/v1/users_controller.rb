# frozen_string_literal: true

module GraphqlToRest
  module DummyApp1
    module Api
      module V1
        class UsersController
          include ::GraphqlToRest::OpenApi::Controller

          open_api do |c|
            c.model('User')

            c.action(:show) do |a|
              a.graphql_action(:user)
            end

            c.action(:create) do |a|
              a.graphql_action(:createUser)
              a.fieldset_parameter.default_value(%i[id email])
              a.graphql_input_type_path(:input)
            end
          end
        end
      end
    end
  end
end
