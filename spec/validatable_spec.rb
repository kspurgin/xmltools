# frozen_string_literal: true

require 'yaml'

require 'spec_helper'

class TestClass
  include Xmltools::Validatable
end

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Xmltools::Validatable' do
  describe 'valid_data' do
    let(:contract){ Xmltools::ConfigContract.new }
    let(:hash){ TestClass.new.valid_data(result) }
    context 'when all data passed is valid' do
      let(:confighash){ YAML.safe_load(ok_config).transform_keys(&:to_sym) }
      let(:result){ contract.call(confighash) }
      it 'returns orig hash' do
        expect(hash).to eq(confighash)
      end
    end

    context 'when some data passed is invalid' do
      let(:confighash){ YAML.safe_load(invalid_schema_config).transform_keys(&:to_sym) }
      let(:result){ contract.call(confighash) }
      it 'returns hash with only valid data' do
        expect(hash.keys.sort).to eq(%i[input_dir recursive])
      end
    end

    context 'when only one data value passed' do
      let(:confighash){ YAML.safe_load(only_recursive_config).transform_keys(&:to_sym) }
      let(:result){ contract.call(confighash) }
      it 'returns hash with only valid, populated data' do
        expect(hash.keys.sort).to eq(%i[recursive])
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
