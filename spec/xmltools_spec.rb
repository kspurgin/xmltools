# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Xmltools do
  it 'has a version number' do
    expect(Xmltools::VERSION).not_to be nil
  end

  describe 'settings' do
    context 'when inititally started' do
      before(:all){ Xmltools.reset_config }
      it 'input_dir = blank' do
        expect(Xmltools.input_dir).to be nil
      end
      it 'schema = blank' do
        expect(Xmltools.schema).to be nil
      end
      it 'recursive = false' do
        expect(Xmltools.recursive).to be nil
      end
    end

    context 'after loading default config' do
      before(:all){ config_reset }
      it 'input_dir = dir from config' do
        cleaned = clean_test_path(Xmltools.input_dir)
        expect(cleaned).to eq('/xmltools/spec/support/fixtures/xml')
      end
      it 'schema = file from config' do
        cleaned = clean_test_path(Xmltools.schema)
        expect(cleaned).to eq('/xmltools/spec/support/fixtures/xsd/mods_schema.xsd')
      end
      it 'recursive = value from file' do
        expect(Xmltools.recursive).to be false
      end
    end

    context 'after loading default config, followed by additional config' do
      before(:all) do
        config_reset
        Xmltools::ConfigLoader.new.call(config_file(ok_config_recursive))
      end
      it 'input_dir = dir from new config' do
        cleaned = clean_test_path(Xmltools.input_dir)
        expect(cleaned).to eq('/xmltools/spec/support/fixtures/xml2')
      end
      it 'schema = file from new config' do
        cleaned = clean_test_path(Xmltools.schema)
        expect(cleaned).to eq('/xmltools/spec/support/fixtures/xsd/mods_schema2.xsd')
      end
      it 'recursive = value from new config' do
        expect(Xmltools.recursive).to be true
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
