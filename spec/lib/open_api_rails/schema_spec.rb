# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OpenApiRails::Schema do
  subject(:schema) { described_class.new(server_urls: server_urls) }

  let(:server_urls) { ['api/v1'] }
  let(:rails_routes) { [double('RailsRoute')] }

  before do
    allow(schema).to receive(:rails_routes).and_return(rails_routes)
  end

  describe '#open_api_json' do
    subject(:open_api_json) { schema.open_api_json }

    it 'returns open api json' do
      expect(open_api_json).to eq(
        openapi: '3.0.0',
        info: {
          title: 'API',
          version: 'v1'
        },
        servers: [
          {
            url: 'api/v1'
          }
        ],
        paths: {},
        components: {
          schemas: {}
        }
      )
    end
  end
end
