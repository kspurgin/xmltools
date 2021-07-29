# frozen_string_literal: true

require 'dry-validation'

require 'xmltools'
require 'xmltools/app_contract'
require 'xmltools/config_loader'

module Xmltools
  module CLI
    module Commands
      # Validations for Validate CLI command
      class ValidateContract < AppContract
        schema do
          optional(:input_dir).value(:string)
          optional(:schema).value(:string)
          optional(:recursive).value(:bool)
          optional(:config).value(:string)
        end

        rule(:config).validate(:existing_dir_or_file)
        rule do
          next if values.data[:config].empty?
          next if rule_error?(:config)

          Xmltools::ConfigLoader.new(values[:config])
        end
        rule(:input_dir).validate(:existing_dir_or_file)
        rule(:input_dir).validate(xml_dir: :recursive)

        rule(:schema).validate(:existing_dir_or_file)
        rule(:schema).validate(:valid_schema)
      end
    end
  end
end
