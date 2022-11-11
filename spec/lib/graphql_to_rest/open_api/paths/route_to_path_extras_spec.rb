# frozen_string_literal: true


RSpec.describe GraphqlToRest::OpenApi::Paths::RouteToPathExtras do
  describe '.call' do
    subject(:call) { described_class.call(route: route) }

    let(:route) { OpenApi::Paths::RouteDecorator.new(rails_route: rails_route) }

    let(:rails_route) do
      Rails.application.routes.routes.detect { _1.path.spec.to_s.starts_with?('/api/v2/:ctx_token/login') }
    end

    before do
      allow(File).to receive(:read).and_call_original
    end

    it 'reads schema details from file' do
      call

      expected_path = Rails.root.join('lib/open_api/path_schemas/api/v2/user_sessions_controller.yml')
      expect(File).to have_received(:read).with(expected_path)
    end

    it 'includes dynamic parameter names' do
      parameters = call.fetch('/{ctx_token}/login').fetch('post').fetch('parameters')
      expect(parameters.pluck('name')).to include('fields[UserSession]')
    end
  end
end
