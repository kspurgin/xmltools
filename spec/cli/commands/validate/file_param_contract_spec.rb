# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Xmltools::CLI::Commands::Validate::FileParamContract' do
  let(:described_class){ Xmltools::CLI::Commands::Validate::FileParamContract }

  # `existing_dir_or_file`, and `valid_schema` rule macros are tested under
  #   `Xmltools::AppContract`
  describe '#call' do
    let(:contract){ described_class.new }
    let(:fileval){ files.join(fixtures_dir, 'xml', 'a.xml') }
    let(:schemaval){ files.join(fixtures_dir, 'xsd', 'mods_schema.xsd') }
    let(:result){ contract.call(file_path: fileval, schema: schemaval) }

    context 'with expected values' do
      it 'is success' do
        expect(result.success?).to be true
      end
    end

    context 'with no filepath given' do
      let(:result){ contract.call(schema: schemaval) }
      it 'is failure' do
        expect(result.failure?).to be true
      end
      it 'has expected message' do
        messages = result.errors.messages.map(&:text)
        msg = 'is missing'
        expect(messages).to eq([msg])
      end
    end

    context 'with path to nonexistent file' do
      let(:fileval){ files.join(fixtures_dir, 'xml', 'z.xml') }
      it 'is failure' do
        expect(result.failure?).to be true
      end
      it 'has expected message' do
        messages = result.errors.messages.map(&:text)
        msg = "file_path does not exist at #{fileval}"
        expect(messages).to eq([msg])
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
