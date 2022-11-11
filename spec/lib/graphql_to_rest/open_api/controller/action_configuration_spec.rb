# frozen_string_literal: true


RSpec.describe GraphqlToRest::OpenApi::Controller::ActionConfiguration do
  subject(:action_configuration) { described_class.new(controller_config: controller_config) }

  let(:controller_config) { GraphqlToRest::OpenApi::Controller::ControllerConfiguration.new }

  describe '#query_parameter' do
    subject(:query_parameter) { action_configuration.query_parameter(name) }

    let(:name) { 'name' }

    it 'always returns query parameter configuration' do
      expect(query_parameter).to be_a(OpenApi::Controller::ParameterConfiguration)
    end
  end

  describe '#path_parameter' do
    subject(:path_parameter) { action_configuration.path_parameter(name) }

    let(:name) { 'name' }

    it 'always returns path parameter configuration' do
      expect(path_parameter).to be_a(OpenApi::Controller::ParameterConfiguration)
    end
  end

  describe '#fieldset_parameter' do
    subject(:fieldset_parameter) { action_configuration.fieldset_parameter }

    it 'returns parameter configuration' do
      expect(fieldset_parameter).to be_a(OpenApi::Controller::ParameterConfiguration)
    end
  end

  describe '#graphql_action' do
    subject(:graphql_action) { action_configuration.graphql_action }

    let(:action_name) { :createUser }

    context 'when action is not set' do
      it { is_expected.to be_nil }
    end

    context 'when action is set' do
      before { action_configuration.graphql_action(action_name) }

      it 'returns action name' do
        expect(graphql_action).to eq(action_name)
      end
    end
  end
end
