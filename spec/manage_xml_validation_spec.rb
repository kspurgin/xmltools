# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Xmltools::ManageXmlValidation' do
  before(:all) do
    config_reset
    Xmltools.config.recursive = true
  end
  describe '#call' do
    let(:manager){ Xmltools::ManageXmlValidation.new }
    let(:result){ manager.call }

    it 'blah' do
      expect(result).to be_a(Xmltools::ManageXmlValidation)
    end
  end
end
# rubocop:enable Metrics/BlockLength
