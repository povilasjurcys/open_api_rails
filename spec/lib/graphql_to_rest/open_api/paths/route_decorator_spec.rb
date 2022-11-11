# frozen_string_literal: true


RSpec.describe GraphqlToRest::OpenApi::Paths::RouteDecorator do
  describe '.call' do
    subject(:route_decorator) { described_class.new(rails_route: rails_route) }

    let(:rails_route) do
      Rails.application.routes.routes.detect { _1.path.spec.to_s.starts_with?('/api/v2/:ctx_token/login') }
    end

    describe '#input_type' do
      subject(:input_type) { route_decorator.input_type.to_type_signature }

      it 'returns correct input type' do
        expect(input_type).to eq('AUTH_PROVIDER_INPUT!')
      end
    end

    describe '#return_type' do
      subject(:return_type) { route_decorator.return_type.to_type_signature }

      it 'returns correct return type' do
        expect(return_type).to eq('UserSession!')
      end
    end

    describe '#action_config' do
      subject(:action_config) { route_decorator.action_config }

      it 'returns correct action config' do
        expect(action_config).to be_a(OpenApi::Controller::ActionConfiguration)
      end
    end

    describe '#controller_config' do
      subject(:controller_config) { route_decorator.controller_config }

      it 'returns correct controller config' do
        expect(controller_config).to be_a(OpenApi::Controller::ControllerConfiguration)
      end
    end

    describe '#http_method' do
      subject(:http_method) { route_decorator.http_method }

      it 'returns correct http method' do
        expect(http_method).to eq('post')
      end
    end

    describe '#open_api_path' do
      subject(:open_api_path) { route_decorator.open_api_path }

      it 'returns correct open api path' do
        expect(open_api_path).to eq('/{ctx_token}/login')
      end
    end

    describe '#path_parameters' do
      subject(:path_parameters) { route_decorator.path_parameters }

      it 'returns correct path parameters' do
        expect(path_parameters).to eq(%w[ctx_token])
      end
    end

    describe '#action_name' do
      subject(:action_name) { route_decorator.action_name }

      it 'returns correct action name' do
        expect(action_name).to eq('create')
      end
    end

    describe '#controller_class' do
      subject(:controller_class) { route_decorator.controller_class }

      it 'returns correct controller class' do
        expect(controller_class).to eq(Api::V2::UserSessionsController)
      end
    end
  end
end
