# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Xmltools::CLI::Commands::ValidateContract' do
  let(:described_class){ Xmltools::CLI::Commands::ValidateContract }
  let(:recurse){ false }

  # `existing_dir_or_file`, `xml_dir`, and `valid_schema` rule macros are tested under
  #   `Xmltools::AppContract`
  describe '#call' do
    let(:contract){ described_class.new }
    let(:dirval){ files.join(fixtures_dir, 'xml') }
    let(:schemaval){ files.join(fixtures_dir, 'xsd', 'mods_schema.xsd') }
    let(:result){ contract.call(input_dir: dirval, schema: schemaval, recursive: false) }

    context 'with expected values' do
      it 'is success' do
        expect(result.success?).to be true
      end
    end

    context 'with nonexistent input_dir' do
      let(:dirval){ files.join(fixtures_dir, 'missing') }
      it 'is failure' do
        expect(result.failure?).to be true
      end
      it 'has expected message' do
        messages = result.errors.messages.map(&:text)
        msg = "input_dir does not exist at #{dirval}"
        expect(messages).to eq([msg])
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
