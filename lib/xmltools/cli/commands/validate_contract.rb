# frozen_string_literal: true

require 'dry-validation'

require 'xmltools'

module Xmltools
  module CLI
    module Commands
      # Validations for Validate CLI command
      class ValidateContract < Dry::Validation::Contract
        schema do
          optional(:input_dir).value(:string)
          optional(:schema).value(:string)
          optional(:recursive).value(:bool)
        end

        rule(:input_dir).validate(:existing_dir)
        rule(:input_dir, :recursive).validate(:xml_dir)
      end
    end
  end
end
