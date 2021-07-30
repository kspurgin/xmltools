# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Xmltools::XmlDirectoryRecursive' do
  let(:dir){ Xmltools::XmlDirectoryRecursive.new }

  describe 'files' do
    before(:all){ Xmltools.config.update({input_dir: fixtures_dir, recursive: true}) }
    let(:result){ dir.files }
    it 'returns an Array' do
      expect(result).to be_a(Array)
    end
    it 'elements in Array are Pathname objects' do
      expect(result.first).to be_a(Pathname)
    end
    it 'lists expected files' do
      expect(result.map(&:to_s).map{ |path| path.sub(fixtures_dir, '') }).to eq(['/xml/a.xml', '/xml2/a.xml'])
    end
  end  
end
# rubocop:enable Metrics/BlockLength
