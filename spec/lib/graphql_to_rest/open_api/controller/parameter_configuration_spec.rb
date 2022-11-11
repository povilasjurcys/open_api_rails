# frozen_string_literal: true


RSpec.describe GraphqlToRest::OpenApi::Controller::ParameterConfiguration do
  subject(:parameter_configuration) { described_class.new(name: initial_name) }

  let(:initial_name) { 'my_param' }

  describe '#default_value' do
    subject(:default_value) { parameter_configuration.default_value }

    context 'when value is not set' do
      it 'returns nil' do
        expect(default_value).to be_nil
      end
    end

    context 'when value is set' do
      before do
        parameter_configuration.default_value('value')
      end

      it 'returns value' do
        expect(default_value).to eq('value')
      end
    end
  end
end
