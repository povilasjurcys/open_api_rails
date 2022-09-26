# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OpenApiRails::Model::ModelConfiguration do
  subject(:model_configuration) { described_class.new }

  describe '#attribute' do
    subject(:attribute) { model_configuration.attribute(:some_attribute) }

    it { is_expected.to be_a(OpenApiRails::Model::AttributeConfiguration) }
  end

  describe '#open_api_json' do
    subject(:open_api_json) { model_configuration.open_api_json }

    before do
      model_configuration.name('DummyItem')
    end

    context 'when no properties are defined' do
      it 'returns only type' do
        expect(open_api_json).to eq(type: 'object')
      end
    end

    context 'when attributes are set' do
      before do
        model_configuration.attribute(:name).type('String!')
        model_configuration.attribute(:email).type('String').type_format(:email)
      end

      it 'returns properties' do # rubocop:disable RSpec/ExampleLength
        expect(open_api_json).to eq(
          type: 'object',
          properties: {
            name: { type: 'string' },
            email: { type: 'string', format: 'email' }
          },
          required: %i[name]
        )
      end
    end
  end
end
