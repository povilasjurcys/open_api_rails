# frozen_string_literal: true


RSpec.describe GraphqlToRest::OpenApi::Paths::GraphqlToSuccessResponse do
  describe '.call' do
    subject(:call) { described_class.call(type: type) }

    let(:type) { ::Types::TimeRegistrationInfoType }

    it 'returns correct schema' do
      actual_schema = call[:'200'][:content][:'application/json'][:schema]
      expect(actual_schema[:properties].keys).to match_array(%i[links meta data])

      actual_data = actual_schema[:properties][:data]
      expect(actual_data[:properties]).to eq(
        attributes: { '$ref': '#/components/schemas/TimeRegistrationInfoType' }
      )
    end
  end
end
