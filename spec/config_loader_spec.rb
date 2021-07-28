# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Xmltools::ConfigLoader' do
  include RSpec::Support::Helpers

  let(:described_class){ Xmltools::ConfigLoader }
  context 'when config file is not found' do
    let(:path){ files.join(fixtures_dir, 'configs', 'nonexistent_config.yml') }
    it 'outputs warning to STDOUT' do
      warning = /WARN -- : Config file does not exist at #{path}/
      expect{ described_class.new(path) }.to output(warning).to_stdout_from_any_process
    end

    it 'returns empty hash' do
      loader = described_class.new(path)
      expect(loader.instance_variable_get(:@hash)).to eq({})
    end
  end

  describe '#path' do
    context 'initialized without path' do
      it 'returns default config path' do
        loader = described_class.new
        default_path = loader.send(:default_file)
        expect(loader.path).to eq(default_path)
      end
    end

    context 'initialized with path' do
      let(:path){ config_file(ok_config) }
      it 'returns given config path' do
        loader = described_class.new(path)
        expect(loader.path).to eq(path)
      end
    end
  end

  describe '#config' do
    context 'bad YAML' do
      before do
        @config = files.join(fixtures_dir, 'configs', 'bad.yml')
        files.write(@config, '*')
      end
      after{ files.delete(@config) }
      let(:loader){ described_class.new(@config) }
      it 'outputs warning to STDOUT' do
        warning = /WARN -- : Invalid config file at #{@config}/
        expect{ described_class.new(@config) }.to output(warning).to_stdout_from_any_process
      end
      it 'calls Config with empty hash' do
        expect(loader.config.hash).to eq({})
      end
    end

    context 'blank YAML file' do
      before do
        @config = files.join(fixtures_dir, 'configs', 'blank.yml')
        files.touch(@config)
      end
      after{ files.delete(@config) }
      let(:loader){ described_class.new(@config) }
      it 'outputs warning to STDOUT' do
        warning = /WARN -- : Empty config file at #{@config}/
        expect{ described_class.new(@config) }.to output(warning).to_stdout_from_any_process
      end
      it 'calls Config with empty hash' do
        expect(loader.config.hash).to eq({})
      end
    end

    context 'ok YAML file' do
      let(:config){ config_file(ok_config) }
      let(:loader){ described_class.new(config) }
      it 'calls Config with expected hash' do
        expect(loader.config.hash.keys).to include(:input_dir)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
