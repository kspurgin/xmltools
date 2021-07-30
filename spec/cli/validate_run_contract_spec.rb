# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Xmltools::CLI::Commands::ValidateRunContract' do
  let(:described_class){ Xmltools::CLI::Commands::ValidateRunContract }

  describe '#call' do
    let(:contract){ described_class.new }
    let(:dirval){ files.join(fixtures_dir, 'xml') }
    let(:schemaval){ files.join(fixtures_dir, 'xsd', 'mods_schema.xsd') }
    let(:recurseval){ true }
    let(:result){ contract.call(data) }

    context 'with all required values' do
      let(:data){ {input_dir: dirval, recursive: recurseval, schema: schemaval} }
      it 'is success' do
        expect(result.success?).to be true
      end

      context 'when type of value is unexpected' do
        let(:recurseval){ 'true' }
        it 'is failure' do
          expect(result.failure?).to be true
        end
        it 'has expected message' do
          msg = 'must be boolean'
          expect(result.errors.messages.first.text).to eq(msg)
        end
      end
    end

    context 'with missing required value' do
      let(:data){ {recursive: recurseval, schema: schemaval} }
      let(:recurseval){ 'true' }
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
