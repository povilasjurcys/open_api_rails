# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OpenApiRails::Model::AttributeConfiguration do
  subject(:attribute_configuration) { described_class.new(:some_attribute) }

  describe '#required?' do
    before do
      attribute_configuration.type('String')
    end

    context 'when required is set' do
      before do
        attribute_configuration.required
      end

      it { is_expected.to be_required }
    end

    context 'when optional is set' do
      before do
        attribute_configuration.optional
      end

      it { is_expected.not_to be_required }
    end

    context 'when required and optional are not set' do
      it { is_expected.not_to be_required }
    end
  end

  describe '#open_api_json' do
    subject(:open_api_json) { attribute_configuration.open_api_json }

    context 'when no properties are defined' do
      it 'returns default type' do
        expect(open_api_json).to eq(type: 'string')
      end
    end

    context 'when type is set' do
      before do
        attribute_configuration.type('String')
      end

      it 'returns type' do
        expect(open_api_json).to eq(type: 'string')
      end
    end

    context 'when description is set' do
      before do
        attribute_configuration.description('Some description')
      end

      it 'returns description' do
        expect(open_api_json).to include(description: 'Some description')
      end
    end

    context 'when format is set' do
      let(:set_type) { nil }

      before do
        set_type
        attribute_configuration.type_format('date-time')
      end

      context 'when type is not set' do
        it 'returns format with default type' do
          expect(open_api_json).to eq(type: 'string', format: 'date-time')
        end
      end

      context 'when type is set before type_format' do
        let(:set_type) do
          attribute_configuration.type('String')
        end

        it 'returns format' do
          expect(open_api_json).to eq(type: 'string', format: 'date-time')
        end
      end

      context 'when type is set after type_format' do
        before do
          attribute_configuration.type('String')
        end

        it 'does not return returns format' do
          expect(open_api_json).not_to include(:format)
        end
      end
    end
  end
end
