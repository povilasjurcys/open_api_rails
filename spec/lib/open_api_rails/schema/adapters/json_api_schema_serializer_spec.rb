# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OpenApiRails::Schema::Adapters::JsonApiSchemaSerializer do
  subject(:json_api_schema_serializer) { described_class.new(schema) }

  let(:schema) { instance_double(OpenApiRails::Schema, paths: schema_paths) }
  let(:schema_paths) { {} }

  describe '#paths' do
    subject(:paths) { json_api_schema_serializer.paths }

    context 'when there are no paths' do
      let(:schema_paths) { {} }

      it { is_expected.to be_empty }
    end

    context 'when there are paths' do
      let(:schema_paths) do
        {
          '/api/v1/users' => {
            'GET' => route_double
          }
        }
      end
      let(:route_double) { instance_double(OpenApiRails::Schema::Route, action: route_action) }
      let(:route_action) { OpenApiRails::Controller::ActionConfiguration.new(:show) }
      let(:get_path) { paths.fetch('/api/v1/users').fetch('GET') }
      let(:success_response) do
        get_path.fetch(:responses).fetch('200')
      end

      let(:success_schema) do
        success_response.fetch(:content).fetch(:'application/json').fetch(:schema)
      end

      let(:string_type_content) do
        {
          content: {
            'application/json': {
              'schema': {
                'type': 'object',
                'properties': {
                  'links': {
                    schema: {
                      '$ref': '#/components/schemas/links'
                    }
                  },
                  'data': {
                    'type': 'string'
                  },
                },
                required: ['data']
              }
            }
          }
        }
      end

      it 'returns paths' do
        expect(paths).to eq(
          '/api/v1/users' => {
            'GET' => {
              responses: {
                '200' => string_type_content
              }
            }
          }
        )
      end

      context 'when path action does not have type set' do
        it 'returns default type' do
          expect(success_schema).to eq(type: 'string')
        end
      end

      context 'when path action has type set' do
        before do
          route_action.type('Boolean!')
        end

        it 'returns type' do
          expect(success_schema).to eq(type: 'boolean')
        end
      end

      context 'when path action has description set' do
        before do
          route_action.description('A description')
        end

        it 'returns description' do
          expect(success_response).to eq(
            **string_type_content,
            description: 'A description'
          )
        end
      end

      context 'when path action has query arguments' do
        before do
          route_action.argument(:id).type('Integer!').in_query
        end

        it 'returns arguments' do
          expect(get_path).to eq(
            responses: { '200' => string_type_content },
            parameters: [
              {
                name: 'id',
                in: :query,
                required: true,
                schema: {
                  type: 'integer'
                }
              }
            ]
          )
        end
      end
    end
  end
end
