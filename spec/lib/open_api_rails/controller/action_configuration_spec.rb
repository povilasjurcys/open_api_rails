# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OpenApiRails::Controller::ActionConfiguration do
  subject(:action_configuration) { described_class.new(:update) }

  describe '#success_status_code' do
    subject(:success_status_code) { action_configuration.success_status_code }

    context 'when status code is not set' do
      it { is_expected.to eq(200) }
    end

    context 'when status_code is set' do
      before do
        action_configuration.success_status_code(999)
      end

      it 'returns new status_code' do
        expect(action_configuration.success_status_code).to eq(999)
      end
    end
  end

  describe '#open_api_json' do
    subject(:open_api_json) { action_configuration.open_api_json }

    context 'when no properties are defined' do
      it { is_expected.to be_empty }
    end

    context 'when description is set' do
      before do
        action_configuration.description('Some description')
      end

      it 'returns description' do
        expect(open_api_json).to eq(
          responses: {
            '200' => {
              description: 'Some description'
            }
          }
        )
      end
    end

    context 'when "type" is set' do
      context 'when "type" is a hash' do
        before do
          action_configuration.type('Hash')
        end

        it 'returns OAS hash type equivalent' do # rubocop:disable RSpec/ExampleLength
          expect(open_api_json).to eq(
            responses: {
              '200' => {
                type: 'Object',
                additionalProperties: true
              }
            }
          )
        end
      end

      context 'when "type" is a string' do
        before do
          action_configuration.type('String')
        end

        it 'returns String type' do # rubocop:disable RSpec/ExampleLength
          expect(open_api_json).to eq(
            responses: {
              '200' => {
                content: {
                  'application/json': {
                    schema: {
                      type: 'string'
                    }
                  }
                }
              }
            }
          )
        end
      end

      context 'when "type" is an array' do
        before do
          action_configuration.type('[String]')
        end

        it 'returns Array type' do
          expect(open_api_json).to eq(
            responses: {
              '200' => {
                description: 'Array',
                content: {
                  'application/json' => {
                    schema: {
                      type: 'array',
                      items: {
                        type: 'string'
                      }
                    }
                  }
                }
              }
            }
          )
        end
      end
    end

    context 'when summary is set' do
      before do
        action_configuration.summary('Some summary')
      end

      it 'returns summary' do
        expect(open_api_json).to eq(summary: 'Some summary')
      end
    end
  end
end
