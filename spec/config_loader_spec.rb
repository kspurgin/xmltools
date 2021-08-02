# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Xmltools::ConfigLoader' do
  subject(:loader) { Xmltools::ConfigLoader.new }
  
  context 'when config file is not found' do
    let(:path){ files.join(fixtures_dir, 'configs', 'nonexistent_config.yml') }
    it 'outputs warning to STDOUT' do
      warning = /WARN -- : Config file does not exist at #{path}/
      expect{ loader.call(path) }.to output(warning).to_stdout_from_any_process
    end
  end

  describe '#call' do
    let(:config){ spy Xmltools::Config }
    before do
      Xmltools::AutoInject.container.enable_stubs!
      Xmltools::AutoInject.container.stub(:app_config, config)
    end
    after do
      Xmltools::AutoInject.container.unstub(:app_config)
    end
    context 'when config file is not found' do
      let(:path){ files.join(fixtures_dir, 'configs', 'nonexistent_config.yml') }

      it 'calls Config with empty hash' do
        loader.call(path)
        expect(config).to have_received(:call).with({})
      end
    end

    context 'bad YAML' do
      before do
        @config = files.join(fixtures_dir, 'configs', 'bad.yml')
        files.write(@config, '*')
      end
      after{ files.delete(@config) }
      let(:result){ loader.call(@config) }
      it 'outputs warning to STDOUT' do
        warning = /WARN -- : Invalid config file at #{@config}/
        expect{ result }.to output(warning).to_stdout_from_any_process
      end
      it 'calls Config with empty hash' do
        result
        expect(config).to have_received(:call).with({})
      end
    end

    context 'blank YAML file' do
      before do
        @config = files.join(fixtures_dir, 'configs', 'blank.yml')
        files.touch(@config)
      end
      after{ files.delete(@config) }
      let(:result){ loader.call(@config) }
      it 'outputs warning to STDOUT' do
        warning = /WARN -- : Empty config file at #{@config}/
        expect{ result }.to output(warning).to_stdout_from_any_process
      end
      it 'calls Config with empty hash' do
        result
        expect(config).to have_received(:call).with({})
      end
    end

    context 'ok YAML file' do
      let(:configpath){ config_file(ok_config) }
      let(:result){ loader.call(configpath) }
      it 'calls Config with expected hash' do
        result
        expected = YAML.safe_load(ok_config)
        expect(config).to have_received(:call).with(expected)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
