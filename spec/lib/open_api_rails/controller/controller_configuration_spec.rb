# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OpenApiRails::Controller::ControllerConfiguration do
  subject(:controller_configuration) { described_class.new }

  describe '#action' do
    subject(:action) { controller_configuration.action(name) }

    let(:name) { :some_action }

    it 'returns action configuration' do
      expect(action).to be_a(::OpenApiRails::Controller::ActionConfiguration)
    end

    it 'sets correct action name' do
      expect(action.name).to eq(name)
    end
  end
end
