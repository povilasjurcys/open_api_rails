# frozen_string_literal: true


RSpec.describe GraphqlToRest::OpenApi::Controller::ControllerConfiguration do
  subject(:controller_configuration) { described_class.new }

  describe '#model' do
    subject(:model) { controller_configuration.model }

    context 'when model is not set' do
      it { is_expected.to be_nil }
    end

    context 'when model is set' do
      let(:model_name) { 'User' }

      before { controller_configuration.model(model_name) }

      it 'returns model name' do
        expect(model).to eq(model_name)
      end
    end
  end

  describe '#action' do
    subject(:action) { controller_configuration.action(action_name) }

    let(:action_name) { 'index' }

    it 'always returns action configuration' do
      expect(action).to be_a(OpenApi::Controller::ActionConfiguration)
    end
  end
end
