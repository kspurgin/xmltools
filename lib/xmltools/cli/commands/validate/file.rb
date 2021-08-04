# frozen_string_literal: true

require 'xmltools/cli'
require 'xmltools/validatable'

module Xmltools
  module CLI
    module Commands
      module Validate
        # Command to validate XML files in a directory
        class File < Dry::CLI::Command
          include AutoInject[:config_loader, :config_validator, 'cli.commands.validate.file_params_validator',
                             'cli.commands.validate.file_run_validator']
          include Xmltools::CLI
          include Xmltools::Validatable

          # rubocop:disable Layout/HeredocIndentation, Layout/ClosingHeredocIndentation
          desc <<~DESC
        Validate XML file.

          If the schema option is specified (and valid) in the default .xmltools.yml file, only the
          file_path option is required.

          If you pass in a non-default .yml config file, the schema value it specifies will be used instead of
          the one in .xmltools.yml.

          If you specify schema on the command line, that value will take precedence over options specified
          in a custom .yml config (if given) or the default .xmltools.yml.
        DESC
          # rubocop:enable Layout/HeredocIndentation, Layout/ClosingHeredocIndentation

          option :file_path, type: :string, desc: 'Path to the XML file to validate'
          option :schema, type: :string, desc: 'Path to the schema to use for validation'
          option :config, type: :string, desc: 'Path to .yml config file'

          # rubocop:disable Layout/LineLength
          example [
            "--file_path=path/to/file --schema=path/to/schema.xsd\n    Use the specified options",
            "--file_path=path/to/file --config=path/to/custom_config.yml\n    Validate the given file, using schema specified in custom config",
            "--file_path=path/to/file\n    Validate the given file, using schema in default config"
          ]
          # rubocop:enable Layout/LineLength

          def call(**options)
            puts "Handling file validation options...\n\n"
            process_config(options) unless options[:config].blank?
            process_remaining(options.tap{ |newhash| newhash.delete(:config) })
            process_runtime_validation
          end

          private

          def failure(result)
            put_command_errors('validate file', result)
            put_command_examples('xmltools validate file')
          end

          def process_config(options)
            config = options[:config]
            config_validation = config_validator.call(config: config)
            config_loader.call(config) if config_validation.success?
          end

          def process_remaining(remaining)
            params = file_params_validator.call(remaining)
            Xmltools.setup(valid_data(params))
          end

          def process_runtime_validation
            run_validation = file_run_validator.call(Xmltools.config.values.compact)
            run_validation.success? ? success(run_validation) : failure(run_validation)
          end

          def success(result)
            puts 'Validating XML file'
            put_app_options(%i[file_path schema]) if result.success?
          end
        end
      end
    end
  end
end
