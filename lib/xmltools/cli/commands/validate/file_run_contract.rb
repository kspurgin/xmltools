# frozen_string_literal: true

require 'dry-validation'

require 'xmltools/app_contract'

module Xmltools
  module CLI
    module Commands
      module Validate
        # Validations for running Validate > File CLI command after all configs/params are set
        class FileRunContract < AppContract
          schema do
            required(:file_path).value(:string)
            required(:schema).value(:string)
          end
        end
      end
    end
  end
end
