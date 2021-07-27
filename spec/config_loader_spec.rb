# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Xmltools::ConfigLoader' do
  include RSpec::Support::Helpers

  let(:described_class){ Xmltools::ConfigLoader }
  context 'when config file is not found' do
    let(:path){ File.join(fixtures_dir, 'configs', 'nonexistent_config.yml') }
    it 'outputs warning to STDOUT' do
      warning = /WARN -- : Config file does not exist at #{path}/
      expect{ described_class.new(path) }.to output(warning).to_stdout_from_any_process
    end

    it 'returns empty hash' do
      loader = described_class.new(path)
      expect(loader.hash).to eq({})
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
      let(:path){ File.join(fixtures_dir, 'configs', 'ok_config.yml') }
      it 'returns given config path' do
        loader = described_class.new(path)
        expect(loader.path).to eq(path)
      end
    end
  end

  describe '#hash' do
  end
end
# rubocop:enable Metrics/BlockLength
