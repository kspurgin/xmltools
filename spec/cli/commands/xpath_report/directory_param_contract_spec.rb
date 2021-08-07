# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Xmltools::CLI::Commands::XpathReport::DirectoryParamContract' do
  let(:described_class){ Xmltools::CLI::Commands::XpathReport::DirectoryParamContract }
  let(:recurse){ false }

  # `existing_dir_or_file`, `xml_dir`, and `valid_xpath` rule macros are tested under
  #   `Xmltools::AppContract`
  describe '#call' do
    let(:contract){ described_class.new }
    let(:dirval){ files.join(fixtures_dir, 'xml') }
    let(:xpathval){ '//*[@script]' }
    let(:reportpathval){ files.join(fixtures_dir, 'newdir', 'report.txt') }
    let(:result){ contract.call(input_dir: dirval, xpath: xpathval, report_path: reportpathval) }

    context 'with expected values' do
      it 'is success' do
        expect(result.success?).to be true
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
