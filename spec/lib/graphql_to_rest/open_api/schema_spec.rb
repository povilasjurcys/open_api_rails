# frozen_string_literal: true

RSpec.describe GraphqlToRest::OpenApi::Schema do
  subject(:schema) { described_class.new }

  describe '#as_json' do
    let(:dumped_json) do
      json = File.read('public/openapi.json')
      JSON.parse(json).deep_symbolize_keys
    end

    it 'matches dumped json' do
      # if you need to update saved_schema, run rake task:
      #   bundle exec rake open_api:schema:dump
      expect(schema.as_json.deep_symbolize_keys).to eq(dumped_json)
    end
  end
end
