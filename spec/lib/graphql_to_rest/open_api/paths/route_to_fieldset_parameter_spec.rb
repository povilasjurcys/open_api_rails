# frozen_string_literal: true


RSpec.describe GraphqlToRest::OpenApi::Paths::RouteToFieldsetParameter do
  describe '.call' do
    subject(:call) { described_class.call(route: route) }

    let(:route) { OpenApi::Paths::RouteDecorator.new(rails_route: rails_route) }

    let(:rails_route) do
      Rails.application.routes.routes.detect { _1.path.spec.to_s.starts_with?('/api/v2/:ctx_token/login') }
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
