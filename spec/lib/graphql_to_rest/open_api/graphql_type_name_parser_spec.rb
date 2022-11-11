# frozen_string_literal: true


RSpec.describe GraphqlToRest::OpenApi::GraphqlTypeNameParser do
  subject(:graphql_type_name_parser) { described_class.new(graphql_type_name: graphql_type_name) }

  let(:graphql_type_name) { 'String!' }

  describe '#required?' do
    context 'when type is ends with a bang' do
      it { is_expected.to be_required }
    end

    context 'when type is not ends with a bang' do
      let(:graphql_type_name) { 'String' }

      it { is_expected.not_to be_required }
    end
  end

  describe '#list?' do
    context 'when type is not surrounded by brackets' do
      it { is_expected.not_to be_list }
    end

    context 'when type is surrounded by brackets' do
      let(:graphql_type_name) { '[String!]!' }

      it { is_expected.to be_list }
    end
  end

  describe '#open_api_schema' do
    subject(:open_api_schema) { graphql_type_name_parser.open_api_schema }

    context 'when type is scalar' do
      it 'returns correct schema' do
        expect(open_api_schema).to eq(type: 'string')
      end
    end

    context 'when type is list' do
      let(:graphql_type_name) { '[String!]!' }

      it 'returns correct schema' do
        expect(open_api_schema).to eq(type: 'array', items: { type: 'string' })
      end
    end

    context 'when type is non-scalar' do
      let(:graphql_type_name) { 'User!' }

      it { is_expected.to be_empty }
    end
  end

  describe '#inner_nullable_graphql_object' do
    subject(:inner_nullable_graphql_object) { graphql_type_name_parser.inner_nullable_graphql_object }

    context 'when type is basic type' do
      it { is_expected.to be_nil }
    end

    context 'when type is non-basic scalar' do
      let(:graphql_type_name) { 'Types::Period' }

      it 'returns GraphQL object' do
        expect(inner_nullable_graphql_object).to eq(Types::Period)
      end
    end

    context 'when type is GraphQL object' do
      let(:graphql_type_name) { '::Types::TimeRegistrationInfoType' }

      it 'returns GraphQL object' do
        expect(inner_nullable_graphql_object).to eq(::Types::TimeRegistrationInfoType)
      end
    end

    context 'when type is GraphqlRails model' do
      let(:graphql_type_name) { '::Graphql::Users::UserDecorator' }

      it 'returns GraphQL object' do
        expect(inner_nullable_graphql_object).to eq(::Graphql::Users::UserDecorator.graphql.graphql_type)
      end
    end
  end

  describe '#open_api_type_name' do
    subject(:open_api_type_name) { graphql_type_name_parser.open_api_type_name }

    context 'when type is basic' do
      it 'returns equivalent OpenAPI type' do
        expect(open_api_type_name).to eq('string')
      end
    end

    context 'when type is custom scalar' do
      let(:graphql_type_name) { '::Types::Period' }

      it 'returns equivalent OpenAPI type' do
        expect(open_api_type_name).to eq('Period')
      end
    end

    context 'when type is GraphqlRails model' do
      let(:graphql_type_name) { '::Graphql::Users::UserDecorator!' }

      it 'returns OpenAPI type based on graphql type name' do
        expect(open_api_type_name).to eq('User')
      end
    end

    context 'when type is GraphQL::Schema::Object' do
      let(:graphql_type_name) { '::Types::TimeRegistrationInfoType' }

      it 'returns OpenAPI type based on graphql type name' do
        expect(open_api_type_name).to eq('TimeRegistrationInfoType')
      end
    end
  end

  describe '#scalar?' do
    context 'when type is basic' do
      it { is_expected.to be_scalar }
    end

    context 'when type is custom scalar' do
      let(:graphql_type_name) { '::Types::Period' }

      it { is_expected.to be_scalar }
    end

    context 'when type is GraphqlRails model' do
      let(:graphql_type_name) { '::Graphql::Users::UserDecorator!' }

      it { is_expected.not_to be_scalar }
    end

    context 'when type is GraphQL::Schema::Object' do
      let(:graphql_type_name) { '::Types::TimeRegistrationInfoType' }

      it { is_expected.not_to be_scalar }
    end
  end
end
