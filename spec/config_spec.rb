# frozen_string_literal: true

require 'spec_helper'
require 'yaml'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Xmltools::Config' do
  let(:described_class){ Xmltools::Config }

  describe '#orig' do
    context 'initialized without param' do
      let(:config){ described_class.new }
      it 'is empty' do
        expect(config.hash).to eq({})
      end
    end

    context 'initialized with empty hash' do
      let(:config){ described_class.new({}) }
      it 'is empty' do
        expect(config.hash).to eq({})
      end
    end

    context 'initialized with hash' do
      let(:inithash){ {a: 'a', b: 'b'} }
      let(:config){ described_class.new(inithash) }
      it 'returns given hash' do
        expect(config.hash).to eq(inithash)
      end
    end
  end

  describe '#hash' do
    let(:confighash){ YAML.load(configdata) }
    let(:config){ described_class.new(confighash) }
    let(:result){ config.hash }
    context 'when valid config' do
      let(:configdata){ ok_config }
      it 'returns hash with only valid config keys' do
        expect(result.keys.sort).to eq(%i[input_dir recursive schema])
      end
    end

    context 'when partially invalid config' do
      let(:configdata){
      <<~CONFIG
        input_dir: #{files.join(fixtures_dir, 'xml')}
        recursive_input_dir: false
        schema: #{files.join(fixtures_dir, 'xsd', 'mods_schema_invalid.xsd')}
      CONFIG
      }
      it 'returns hash with only valid config keys' do
        expect(result.keys.sort).to eq(%i[input_dir recursive])
      end
    end
  end

  describe '#validation_result' do
    let(:config){ described_class.new(confighash) }

    context 'valid config' do
      let(:confighash){ YAML.load(ok_config) }
      let(:result){ config.validation_result }
      it 'is success' do
        expect(result.success?).to be true
      end
    end

    context 'blank config' do
      let(:confighash){ {} }
      let(:result){ config.validation_result }
      it 'is success' do
        expect(result.success?).to be true
      end
    end

  end
end
# rubocop:enable Metrics/BlockLength
