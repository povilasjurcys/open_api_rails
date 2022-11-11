# frozen_string_literal: true


RSpec.describe GraphqlToRest::OpenApi::Paths::RouteToParameters do
  describe '.call' do
    subject(:call) { described_class.call(route: route) }

    let(:route) { GraphqlToRest::OpenApi::Paths::RouteDecorator.new(rails_route: rails_route) }

    let(:rails_route) do
      Rails.application.routes.routes.detect { _1.path.spec.to_s.starts_with?('/api/v2/:ctx_token/login') }
    end

    it 'returns correct parameters' do
      expect(call.count).to eq(2)
      expect(call.first).to include(name: 'fields[UserSession]')
      expect(call.second).to eq(
        name: 'ctx_token',
        in: 'path',
        required: true,
        schema: {
          type: 'string',
          example: 'c1d1',
          description: 'Context token'
        }
      )
    end
  end
end
