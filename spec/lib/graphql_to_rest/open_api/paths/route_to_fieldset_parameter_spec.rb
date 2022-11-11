# frozen_string_literal: true


RSpec.describe GraphqlToRest::OpenApi::Paths::RouteToFieldsetParameter do
  describe '.call' do
    subject(:call) { described_class.call(route: route) }

    let(:route) { GraphqlToRest::OpenApi::Paths::RouteDecorator.new(rails_route: rails_route) }

    let(:rails_route) do
      rails_route_double(:post, '/api/v1/users(.:format)', "#users#create")
    end

    it 'returns correct schema' do
      expect(call).to eq(
        description: 'Comma separated list of #/components/schemas/UserSession fields that must be returned',
        name: 'fields[UserSession]',
        in: 'query',
        required: false,
        style: 'simple',
        explode: false,
        schema: {
          type: 'array',
          default: 'token',
          items: {
            type: 'string',
            enum: %w[id token]
          }
        }
      )
    end
  end
end
