# frozen_string_literal: true


RSpec.describe GraphqlToRest::OpenApi::Paths::RouteToPathSchema do
  describe '.call' do
    subject(:call) { described_class.call(route: route) }

    let(:route) { OpenApi::Paths::RouteDecorator.new(rails_route: rails_route) }

    let(:rails_route) do
      Rails.application.routes.routes.detect { _1.path.spec.to_s.starts_with?('/api/v2/:ctx_token/login') }
    end

    before do
      allow(OpenApi::Paths::RouteToPathExtras).to receive(:call).and_call_original
      allow(OpenApi::Paths::RouteToParameters).to receive(:call).and_call_original
    end

    it 'calculates path extras from route' do
      call

      expect(OpenApi::Paths::RouteToPathExtras).to have_received(:call).with(route: route)
    end

    it 'extracts parameters from route' do
      call

      expect(OpenApi::Paths::RouteToParameters).to have_received(:call).with(route: route)
    end

    it 'has correct structure' do
      path_spec = call.fetch('/{ctx_token}/login').fetch('post')
      expect(path_spec.keys).to match_array(%w[parameters requestBody responses])
    end
  end
end
