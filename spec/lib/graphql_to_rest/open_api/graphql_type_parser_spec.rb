# frozen_string_literal: true

RSpec.describe GraphqlToRest::OpenApi::GraphqlTypeParser do
  subject(:graphql_type_name_parser) { described_class.new(unparsed_type: unparsed_type) }

  describe '#open_api_type_name' do
    subject(:open_api_type_name) { graphql_type_name_parser.open_api_type_name }

    let(:unparsed_type) { GraphQL::Types::String }

    context 'when type is basic' do
      it { is_expected.to eq('string') }
    end

    context 'when type is GraphQL::Object' do
      let(:unparsed_type) { Types::SettingType.to_non_null_type }

      it { is_expected.to eq('Setting') }
    end
  end

  describe '#inner_nullable_graphql_object' do
    subject(:inner_nullable_graphql_object) { graphql_type_name_parser.inner_nullable_graphql_object }

    let(:unparsed_type) { Types::SettingType.to_non_null_type }

    context 'when type is GraphQL::Object' do
      let(:unparsed_type) { Types::SettingType.to_non_null_type }

      it 'returns unwrapped type' do
        expect(inner_nullable_graphql_object).to eq(Types::SettingType)
      end
    end
  end

  describe '#scalar?' do
    context 'when type is basic' do
      let(:unparsed_type) { GraphQL::Types::String }

      it { is_expected.to be_scalar }
    end

    context 'when type is GraphQL::Object' do
      let(:unparsed_type) { Types::SettingType }

      it { is_expected.not_to be_scalar }
    end
  end
end
