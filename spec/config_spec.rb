# frozen_string_literal: true

require 'spec_helper'
require 'yaml'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Xmltools::Config' do
  let(:described_class){ Xmltools::Config }

  describe '#hash' do
    let(:confighash){ YAML.safe_load(configdata) }
    let(:config){ described_class.new }
    let(:result){ config.call(confighash) }
    before(:each){ Xmltools.reset_config }
    context 'when valid config' do
      let(:configdata){ ok_config }
      it 'returns hash with only valid config keys' do
        expect(result.keys.sort).to eq(%i[input_dir recursive schema])
      end
    end

    context 'when partially invalid config' do
      let(:configdata){ invalid_schema_config }
      it 'returns hash with only valid config keys' do
        expect(result.keys.sort).to eq(%i[input_dir recursive])
      end
    end

    context 'when config does not include all expected keys' do
      let(:configdata){ only_recursive_config }
      it 'returns hash with valid, populated data' do
        expect(result).to eq({recursive: true})
      end
    end

    context 'when config includes extra keys' do
      let(:configdata){ extra_setting_config }
      it 'returns hash with valid, populated data' do
        expect(result.keys).to eq(%i[input_dir])
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
