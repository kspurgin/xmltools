# frozen_string_literal: true

require 'xmltools/cli'
require 'xmltools/validatable'

module Xmltools
  module CLI
    module Commands
      module XpathReport
        # Command to validate XML files in a directory
        class Directory < Dry::CLI::Command
          include AutoInject[:config_loader, :config_validator, 'cli.commands.xpath_report.dir_params_validator',
                             'cli.commands.xpath_report.dir_run_validator']
          include Xmltools::CLI
          include Xmltools::Validatable

          # rubocop:disable Layout/HeredocIndentation, Layout/ClosingHeredocIndentation
          desc <<~DESC
        Generates a report of all occurrences of a given xpath in all files in a directory.
        DESC
          # rubocop:enable Layout/HeredocIndentation, Layout/ClosingHeredocIndentation

          option :input_dir, type: :string, desc: 'Path to the directory containing the XML files'
          option :xpath, type: :string, desc: 'The xpath to report on'
          option :report_path, type: :string, desc: 'Where to write the report'
          option :config, type: :string, desc: 'Path to .yml config file'

          def call(**options)
            puts "Handling directory xpath report options...\n\n"
            process_config(options) unless options[:config].blank?
            process_remaining(options.tap{ |newhash| newhash.delete(:config) })
            process_runtime_validation
          end

          private

          def failure(result)
            put_command_errors('xpath_report directory', result)
            put_command_examples('xmltools xpath_report directory')
          end

          def process_config(options)
            config = options[:config]
            config_validation = config_validator.call(config: config)
            config_loader.call(config) if config_validation.success?
          end

          def process_remaining(remaining)
            params = dir_params_validator.call(remaining)
            Xmltools.setup(valid_data(params))
          end

          def process_runtime_validation
            run_validation = dir_run_validator.call(Xmltools.config.values.compact)
            run_validation.success? ? success(run_validation) : failure(run_validation)
          end

          def success(result)
            puts 'Reporting on xpath in XML in directory'
            put_app_options(%i[input_dir xpath report_path]) if result.success?
          end
        end
      end
    end
  end
end
