# frozen_string_literal: true


RSpec.describe GraphqlToRest::OpenApi::Paths::RouteToPathSchema do
  describe '.call' do
    subject(:call) { described_class.call(route: route) }

    let(:route) do
      GraphqlToRest::OpenApi::Paths::RouteDecorator.new(rails_route: rails_route)
    end

    let(:rails_route) do
      rails_route_double(:post, '/api/v1/users/', 'graphql_to_rest/dummy_app1/api/v1/users#create')
    end

    before do
      allow(GraphqlToRest::OpenApi::Paths::RouteToPathExtras)
        .to receive(:call).and_call_original

      allow(GraphqlToRest::OpenApi::Paths::RouteToParameters)
        .to receive(:call).and_call_original
    end

    it 'calculates path extras from route' do
      call

      expect(GraphqlToRest::OpenApi::Paths::RouteToPathExtras)
        .to have_received(:call).with(route: route)
    end

    it 'extracts parameters from route' do
      call

      expect(GraphqlToRest::OpenApi::Paths::RouteToParameters)
        .to have_received(:call).with(route: route)
    end

    it 'has correct structure' do
      path_spec = call.fetch('/{ctx_token}/login').fetch('post')
      expect(path_spec.keys).to match_array(%w[parameters requestBody responses])
    end
  end
end
