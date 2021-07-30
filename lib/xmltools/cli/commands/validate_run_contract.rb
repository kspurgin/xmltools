# frozen_string_literal: true

require 'dry-validation'

require 'xmltools/app_contract'

module Xmltools
  module CLI
    module Commands
      # Validations for running Validate CLI command after all configs/params are set
      class ValidateRunContract < AppContract
        schema do
          required(:input_dir).value(:string)
          required(:schema).value(:string)
          required(:recursive).value(:bool)
        end
      end
    end
  end
end
