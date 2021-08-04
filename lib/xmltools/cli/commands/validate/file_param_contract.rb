# frozen_string_literal: true

require 'dry-validation'

require 'xmltools/app_contract'

module Xmltools
  module CLI
    module Commands
      module Validate
        # Validations for Validate > File CLI command parameters
        class FileParamContract < AppContract
          schema do
            required(:file_path).value(:string)
            optional(:schema).value(:string)
          end

          rule(:file_path).validate(:existing_dir_or_file)

          rule(:schema).validate(:existing_dir_or_file)
          rule(:schema).validate(:valid_schema)
        end
      end
    end
  end
end
