# frozen_string_literal: true


RSpec.describe GraphqlToRest::OpenApi::GraphqlToComponentsSchema do
  describe '.call' do
    subject(:call) { described_class.call(type: type) }

    context 'when type is GraphqlRails::Model' do
      let(:type) { ::Graphql::Users::ContractTemplateDecorator }

      it 'returns correct schema' do
        expect(call).to eq(
          'ContractTemplate' => {
            type: 'object',
            properties: {
              'id' => { type: 'string' },
              'title' => { type: 'string' },
              'filename' => { type: 'string' },
              'isHideFromOther' => { type: 'boolean' },
              'placeholders' => {
                type: 'array',
                items: { type: 'string' }
              }
            },
            required: %w[roleIds shopIds additionalRoleIds isHideFromOther placeholders contractType]
          }
        )
      end
    end

    context 'when type is GraphQL::Schema::Object' do
      let(:type) { ::Types::ExtraFieldType }

      it 'returns correct schema' do
        expect(call).to eq(
          'ExtraFieldType' => {
            properties: {
              'default' => { type: 'string' },
              'ftype' => { type: 'string' },
              'id' => { type: 'string' },
              'name' => { type: 'string' },
              'parentId' => { type: 'string' },
              'required' => { type: 'boolean' },
              'section' => { type: 'string' },
              'sectionName' => { type: 'string' },
              'showByDependency' => { type: 'boolean' },
              'triggerValues' => {
                items: { type: 'string' },
                type: 'array'
              },
              'value' => { type: 'string' }
            },
            required: %w[id ftype name roles],
            type: 'object'
          }
        )
      end
    end

    context 'when type is GraphQL::Schema::Enum' do
      let(:type) { ::Types::GenderEnum }

      it 'returns correct schema' do
        expect(call).to eq(
          'GenderEnum' => {
            type: 'string',
            enum: %w[MALE FEMALE]
          }
        )
      end
    end
  end
end
