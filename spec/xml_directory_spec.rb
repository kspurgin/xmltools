# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Xmltools::XmlDirectory' do
  let(:dir){ Xmltools::XmlDirectory.new }

  describe 'create' do
    before(:all){ Xmltools.config.update({input_dir: File.join(fixtures_dir, 'xml')}) } 
    let(:result){ dir.create }
    context 'when not recursive' do
      before(:all){ Xmltools.config.update({recursive: false}) }
      it 'returns an XmlDirectory' do
        expect(result).to be_a(Xmltools::XmlDirectory)
      end
    end

    context 'when recursive' do
      before(:all){ Xmltools.config.update({recursive: true}) }
      it 'returns an XmlDirectoryRecursive' do
        expect(result).to be_a(Xmltools::XmlDirectoryRecursive)
      end
    end
  end

  describe 'files' do
    before(:all){ Xmltools.config.update({input_dir: File.join(fixtures_dir, 'xml'), recursive: false}) }
    let(:result){ dir.files }
    it 'returns an Array' do
      expect(result).to be_a(Array)
    end
    it 'elements in Array are Pathname objects' do
      expect(result.first).to be_a(Pathname)
    end
    it 'lists expected files' do
      expect(result.map(&:basename).map(&:to_s)).to eq(['a.xml'])
    end
  end
end
# rubocop:enable Metrics/BlockLength
