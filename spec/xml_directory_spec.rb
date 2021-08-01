# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Xmltools::XmlDirectory' do
  let(:dir){ Xmltools::XmlDirectory.new }

  describe 'call' do
    context 'when not recursive' do
      before(:all){ Xmltools.config.update({input_dir: File.join(fixtures_dir, 'xml'), recursive: false}) }
      let(:result){ dir.call }
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

    context 'when recursive' do
      before(:all){ Xmltools.config.update({input_dir: File.join(fixtures_dir), recursive: true}) }
      let(:result){ dir.call }
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
end
# rubocop:enable Metrics/BlockLength
