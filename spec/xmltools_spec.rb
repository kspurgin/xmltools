# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Xmltools do
  it 'has a version number' do
    expect(Xmltools::VERSION).not_to be nil
  end

  describe 'settings' do
    before(:all){ Xmltools.reset_config }

    context 'when inititally started' do
      it 'input_dir = blank' do
        expect(Xmltools.input_dir).to eq('')
      end
      it 'schema = blank' do
        expect(Xmltools.schema).to eq('')
      end
      it 'recursive = false' do
        expect(Xmltools.recursive).to be false
      end
    end

    context 'after given a config' do
      before do
        Xmltools::ConfigLoader.new(config_file(ok_config_recursive))
      end
      it 'input_dir = dir from config' do
        cleaned = clean_test_path(Xmltools.input_dir)
        expect(cleaned).to eq('/xmltools/spec/support/fixtures/xml')
      end
      it 'schema = file from config' do
        cleaned = clean_test_path(Xmltools.schema)
        expect(cleaned).to eq('/xmltools/spec/support/fixtures/xsd/mods_schema.xsd')
      end
      it 'recursive = value from file' do
        expect(Xmltools.recursive).to be true
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
