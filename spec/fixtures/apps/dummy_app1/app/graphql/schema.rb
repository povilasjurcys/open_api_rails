module GraphqlToRest
  module DummyApp1
    require_relative './query_type'
    require_relative './mutation_type'

    class Schema < GraphQL::Schema
      query QueryType
      mutation MutationType
    end
  end
end
