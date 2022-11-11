# frozen_string_literal: true


RSpec.describe GraphqlToRest::OpenApi::GraphqlToComponentsRequestBody do
  describe '.call' do
    subject(:call) { described_class.call(type: type, subtype: subtype) }

    let(:subtype) { nil }

    context 'when type is GraphqlRails::Model input' do
      let(:type) { ::Graphql::Users::ContractTemplateDecorator }
      let(:subtype) { :contract_template_attachment_file_input }

      it 'returns correct schema' do
        expect(call).to eq(
          'ContractTemplateAttachmentFileInput' => {
            properties: {
              'attachmentId' => { type: 'string' },
              'id' => { type: 'string' },
              'name' => { type: 'string' }
            },
            type: 'object'
          }
        )
      end
    end

    context 'when type is GraphQL::Schema::InputObject' do
      let(:type) { ::Types::DayInputType }

      it 'returns correct schema' do
        expect(call).to eq(
          'DayInput' => {
            properties: {
              'available' => { type: 'boolean' },
              'date' => { format: 'date', type: 'string' },
              'isFullDay' => { type: 'boolean' },
              'note' => { type: 'string' },
              'shopId' => { type: 'string' },
              'entries' => {
                items: {
                  '$ref': '#/components/requestBodies/AvailabilityInput'
                },
                type: 'array'
              }
            },
            required: %w[date shopId isFullDay],
            type: 'object'
          }
        )
      end
    end
  end
end
