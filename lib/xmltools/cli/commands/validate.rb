# frozen_string_literal: true

require 'xmltools'

module Xmltools
  module CLI
    module Commands
      # Command to validate XML files in a directory
      class Validate < Dry::CLI::Command
        desc 'Validate XML files in a directory.'
        option :input_dir, type: :string, default: '', desc: 'Path to the directory containing the XML to validate'
        option :schema, type: :string, default: '', desc: 'Path to the schema to use for validation'
        option :recursive, type: :boolean, default: false, desc: 'Whether to traverse the given directory recursively'
        option :config, type: :string, default: '', desc: 'Path to .yml config file'

        def call(**options)
          puts 'Validating XML'
          contract = ValidateContract.new

          # rubocop:disable Lint/UselessAssignment
          validated = contract.call(
            input_dir: options.fetch(:input_dir, ''),
            schema: options.fetch(:schema, ''),
            recursive: options.fetch(:recursive, false),
            config: options.fetch(:config, '')
          )
          # rubocop:enable Lint/UselessAssignment
        end
      end
    end
  end
end
