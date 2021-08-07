# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Xmltools::CLI::Commands::XpathReport::Directory' do
  let(:cli){ Dry::CLI.new(Xmltools::CLI::Commands) }
  let(:dirval){ files.join(fixtures_dir, 'xml') }
  let(:schemaval){ files.join(fixtures_dir, 'xsd', 'mods_schema.xsd') }
  let(:recurse){ '--no-recursive' }
  let(:output){ capture_output{ cli.call(arguments: args) } }
  let(:handling){ "Handling directory validation options...\n\n" }
  let(:validating){ "Validating XML in directory\n" }
  let(:errmsg){ "Cannot validate directory due to errors:\n" }

  context 'with validate directory' do
    let(:args){ %w[validate directory] }
    context 'when no default config' do
      before(:each){ Xmltools.reset_config }
      it 'shows errors and help' do
        errs = "  ERROR: input_dir is missing\n  ERROR: recursive is missing\n  ERROR: schema is missing\n"
        expected = "#{handling}#{errmsg}#{errs}"
        expect(output).to include(expected)
      end
    end

    context 'with default config' do
      before(:each){ config_reset }
      it 'shows help' do
        expected = "#{handling}#{validating}"
        expect(output).to include(expected)
      end
    end
  end

  context 'with validate directory --config' do
    before(:all){ config_reset }
    let(:config){ config_file(ok_config_recursive) }
    let(:args){ ['validate', 'directory', "--config=#{config}"] }
    it 'changes the application config settings' do
      old_settings = Xmltools.config.values.dup
      cli.call(arguments: args)
      expect(Xmltools.config.values).not_to eq(old_settings)

      yamlhash = YAML.safe_load(ok_config_recursive).transform_keys(&:to_sym)
      expect(compare_config(yamlhash)).to be true
    end
  end

  context 'when no value for input_dir set by config' do
    context 'when no value for input_dir passed as param' do
      before(:all){ Xmltools.reset_config }
      let(:args){ ['validate', 'directory', "--schema=#{schemaval}", recurse] }
      it 'outputs errors and help' do
        errs = "  ERROR: input_dir is missing\n"
        expected = "#{handling}#{errmsg}#{errs}"
        expect(output).to include(expected)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
