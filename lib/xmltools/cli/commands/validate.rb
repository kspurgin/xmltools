# frozen_string_literal: true

require 'xmltools/cli'
require 'xmltools/validatable'

module Xmltools
  module CLI
    module Commands
      # Command to validate XML files in a directory
      class Validate < Dry::CLI::Command
        include AutoInject[:config_loader, :config_validator, 'cli.commands.validate_params_validator',
                           'cli.commands.validate_run_validator']
        include Xmltools::CLI
        include Xmltools::Validatable

        # rubocop:disable Layout/HeredocIndentation
        desc <<~DESC
        Validate XML files in a directory.

          If all options are specified (and valid) in the default .xmltools.yml file, no options are required.

          If you pass in a non-default .yml config file, any valid options it specifies will be used instead of
          the values in .xmltools.yml.

          If you specify input_dir, schema, and/or recursive options on the command line, those option values
          will take precedence over options specified in a custom .yml config (if given) or the default
          .xmltools.yml.
        DESC
        # rubocop:enable Layout/HeredocIndentation

        option :input_dir, type: :string, desc: 'Path to the directory containing the XML to validate'
        option :schema, type: :string, desc: 'Path to the schema to use for validation'
        option :recursive, type: :boolean, desc: 'Whether to traverse the given directory recursively'
        option :config, type: :string, desc: 'Path to .yml config file'

        # rubocop:disable Layout/LineLength
        example [
          "--input_dir=path/to/dir --schema=path/to/schema.xsd --no-recursive\n    Use the specified options, without recursively traversing the input directory",
          "--input_dir=path/to/dir --schema=path/to/schema.xsd --recursive\n    Use the specified options, recursively traversing the input directory",
          "--input_dir=path/to/dir --config=path/to/custom_config.yml\n    Validate files in given directory, overiding any input_dir named in the\n    given custom config. The other options are loaded from the custom\n    config",
          "--config=path/to/custom_config.yml\n    Use the options specified in the config file given",
          "  \n    Uses options specified in .xmltools.yml"
        ]
        # rubocop:enable Layout/LineLength

        def call(**options)
          puts "Handling validation options...\n\n"
          process_config(options) unless options[:config].blank?
          process_remaining(options.tap{ |newhash| newhash.delete(:config) })
          process_runtime_validation
        end

        private

        def failure(result)
          put_command_errors('validate', result)
          put_command_examples('xmltools validate')
        end

        def process_config(options)
          config = options[:config]
          config_validation = config_validator.call(config: config)
          config_loader.call(config) if config_validation.success?
        end

        def process_remaining(remaining)
          params = validate_params_validator.call(remaining)
          Xmltools.setup(valid_data(params))
        end

        def process_runtime_validation
          run_validation = validate_run_validator.call(Xmltools.config.values.compact)
          run_validation.success? ? success(run_validation) : failure(run_validation)
        end

        def success(result)
          puts 'Validating XML'
          put_app_options(%i[input_dir schema recursive]) if result.success?
        end
      end
    end
  end
end
