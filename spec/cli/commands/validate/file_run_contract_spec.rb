# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Xmltools::CLI::Commands::Validate::FileRunContract' do
  let(:described_class){ Xmltools::CLI::Commands::Validate::FileRunContract }

  describe '#call' do
    let(:contract){ described_class.new }
    let(:fileval){ files.join(fixtures_dir, 'xml', 'a.xml') }
    let(:schemaval){ files.join(fixtures_dir, 'xsd', 'mods_schema.xsd') }
    let(:result){ contract.call(data) }

    context 'with all required values' do
      let(:data){ {file_path: fileval, schema: schemaval} }
      it 'is success' do
        expect(result.success?).to be true
      end

      context 'when type of value is unexpected' do
        let(:fileval){ %i[a b c] }
        it 'is failure' do
          expect(result.failure?).to be true
        end
        it 'has expected message' do
          msg = 'must be a string'
          expect(result.errors.messages.first.text).to eq(msg)
        end
      end
    end

    context 'with missing required value' do
      let(:data){ {schema: schemaval} }
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
