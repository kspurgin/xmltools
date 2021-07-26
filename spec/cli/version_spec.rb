# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Xmltools::CLI::Commands::Version' do
  let(:cli){ Dry::CLI.new(Xmltools::CLI::Commands) }
  let(:output){ capture_output{ cli.call(arguments: args) } }

  context 'with: version' do
    let(:args){ ['version'] }
    it 'returns version' do
      expect(output).to eq("#{Xmltools::VERSION}\n")
    end
  end

  context 'with: v' do
    let(:args){ ['v'] }
    it 'returns version' do
      expect(output).to eq("#{Xmltools::VERSION}\n")
    end
  end

  context 'with: -v' do
    let(:args){ ['-v'] }
    it 'returns version' do
      expect(output).to eq("#{Xmltools::VERSION}\n")
    end
  end

  context 'with: --version' do
    let(:args){ ['--version'] }
    it 'returns version' do
      expect(output).to eq("#{Xmltools::VERSION}\n")
    end
  end
end
# rubocop:enable Metrics/BlockLength
