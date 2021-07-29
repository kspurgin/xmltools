# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Xmltools::CLI::Commands::Validate' do
  before(:all){ Xmltools.reset_config }
  let(:cli){ Dry::CLI.new(Xmltools::CLI::Commands) }
  let(:output){ capture_output{ cli.call(arguments: args) } }

  context 'with validate' do
    let(:args){ ['validate'] }
    it 'returns message about validating' do
      expected = "Validating XML\n"
      expect(output).to eq(expected)
    end
  end

  context 'with validate --config' do
    let(:config){ config_file(ok_config_recursive) }
    let(:args){ ['validate', "--config=#{config}"] }
    it 'changes the application config settings' do
      old_settings = Xmltools.config.values.dup
      cli.call(arguments: args)
      expect(Xmltools.config.values).not_to eq(old_settings)
    end
    it 'application config settings now match given config' do
      yamlhash = YAML.safe_load(ok_config_recursive).transform_keys(&:to_sym)
      expect(Xmltools.config.values).to eq(yamlhash)
    end
  end
end
# rubocop:enable Metrics/BlockLength
