# frozen_string_literal: true

require 'dry-validation'

require 'xmltools'
require 'xmltools/app_contract'

module Xmltools
  module CLI
    module Commands
      # Validations for Validate CLI command
      class ValidateContract < AppContract
        schema do
          optional(:input_dir).value(:string)
          optional(:schema).value(:string)
          optional(:recursive).value(:bool)
        end

        rule(:input_dir).validate(:existing_dir_or_file)
        rule(:schema).validate(:existing_dir_or_file)

        rule(:input_dir, :recursive).validate(:xml_dir) do
          result if rule_error?(:input_dir)
        end

      end
    end
  end
end