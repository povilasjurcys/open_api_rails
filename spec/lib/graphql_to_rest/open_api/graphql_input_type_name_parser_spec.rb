# frozen_string_literal: true


RSpec.describe GraphqlToRest::OpenApi::GraphqlInputTypeNameParser do
  subject(:graphql_input_type_name_parser) do
    described_class.new(graphql_type_name: graphql_type_name, subtype: subtype)
  end

  let(:graphql_type_name) { 'String!' }
  let(:subtype) { nil }

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
    subject(:open_api_schema) { graphql_input_type_name_parser.open_api_schema }

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
      let(:graphql_type_name) { 'UserInput!' }

      it 'returns reference to schema' do
        expect(open_api_schema).to eq('$ref': '#/components/requestBodies/UserInput')
      end
    end
  end

  describe '#inner_nullable_graphql_object' do
    subject(:inner_nullable_graphql_object) do
      graphql_input_type_name_parser.inner_nullable_graphql_object
    end

    context 'when type is basic type' do
      it { is_expected.to be_nil }
    end

    context 'when type is non-basic scalar' do
      let(:graphql_type_name) { 'Types::Period' }

      it 'returns GraphQL object' do
        expect(inner_nullable_graphql_object).to eq(Types::Period)
      end
    end

    context 'when type is GraphQL input object' do
      let(:graphql_type_name) { '::Types::TimeInputType' }

      it 'returns GraphQL object' do
        expect(inner_nullable_graphql_object).to eq(::Types::TimeInputType)
      end
    end

    context 'when type is GraphqlRails model' do
      let(:graphql_type_name) { '::Graphql::ContractDecorator' }
      let(:subtype) { :contract_create_input }

      it 'returns GraphQL object' do
        graphql = Graphql::ContractDecorator.graphql
        expected_type = graphql.input(:contract_create_input).graphql_input_type

        expect(inner_nullable_graphql_object).to eq(expected_type)
      end
    end
  end

  describe '#open_api_type_name' do
    subject(:open_api_type_name) { graphql_input_type_name_parser.open_api_type_name }

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

    context 'when type is GraphqlRails model input' do
      let(:graphql_type_name) { '::Graphql::ContractDecorator' }
      let(:subtype) { :contract_create_input }

      it 'returns OpenAPI type based on graphql type name' do
        expect(open_api_type_name).to eq('ContractCreateInput')
      end
    end

    context 'when type is GraphQL::Schema::InputObject' do
      let(:graphql_type_name) { '::Types::TimeInputType' }

      it 'returns OpenAPI type based on graphql type name' do
        expect(open_api_type_name).to eq('TimeInput')
      end
    end
  end
end
