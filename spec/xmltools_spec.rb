# frozen_string_literal: true

require 'spec_helper'

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
        Xmltools::ConfigLoader.new(files.join(fixtures_dir, 'configs', 'ok_config.yml'))
      end
      it 'input_dir = blank' do
        expect(Xmltools.input_dir).to eq('/Users/kristina/data/islandora/mods/i7_mods')
      end
      it 'schema = blank' do
        expect(Xmltools.schema).to eq('/Users/kristina/data/mods/mods-3-6.xsd')
      end
      it 'recursive = false' do
        expect(Xmltools.recursive).to be false
      end
    end
  end
end
