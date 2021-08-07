# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Xmltools::CLI::Commands::XpathReport::DirectoryRunContract' do
  let(:described_class){ Xmltools::CLI::Commands::XpathReport::DirectoryRunContract }

  describe '#call' do
    let(:contract){ described_class.new }
    let(:dirval){ files.join(fixtures_dir, 'xml') }
    let(:xpathval){ '//*[@script and not(@altRepGroup)]' }
    let(:reportpathval){ files.join(fixtures_dir, 'xpath_report.txt') }
    let(:result){ contract.call(data) }

    context 'with all required values' do
      let(:data){ {input_dir: dirval, xpath: xpathval, report_path: reportpathval} }
      it 'is success' do
        expect(result.success?).to be true
      end
    end

    context 'with missing required value' do
      let(:data){ {input_dir: dirval, report_path: reportpathval} }
      it 'is failure' do
        expect(result.failure?).to be true
      end
      it 'has expected message' do
        msg = 'is missing'
        expect(result.errors.messages.first.text).to eq(msg)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
