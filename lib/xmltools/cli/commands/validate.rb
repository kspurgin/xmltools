# frozen_string_literal: true

require 'xmltools'

module Xmltools
  module CLI
    module Commands
      # Command to validate XML files in a directory
      class Validate < Dry::CLI::Command
        desc 'Validate XML files in a directory'
        option :input_dir, type: :string, default: '', desc: 'Path to the directory containing the XML to validate'
        option :schema, type: :string, default: '', desc: 'Path to the schema to use for validation'
        option :recursive, type: :boolean, default: false, desc: 'Whether to traverse the given directory recursively'

        def call(**options)
          contract = ValidateContract.new
          validated = contract.call(
            input_dir: options.fetch(:input_dir, ''),
            schema: options.fetch(:schema, ''),
            recursive: options.fetch(:recursive, false)
          )
          binding.pry
#          puts "#{options.fetch(input).inspect} -- #{options.fetch(schema).inspect}"
          #          Xmltools::Validator.new(input: input, schema: schema)
        end

        private
      end
    end
  end
end
