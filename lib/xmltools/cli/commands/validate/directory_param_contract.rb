# frozen_string_literal: true

require 'dry-validation'

require 'xmltools/app_contract'

module Xmltools
  module CLI
    module Commands
      module Validate
        # Validations for Validate CLI command parameters
        class DirectoryParamContract < AppContract
          schema do
            optional(:input_dir).value(:string)
            optional(:schema).value(:string)
            optional(:recursive).value(:bool)
          end

          rule(:input_dir).validate(:existing_dir_or_file)
          rule(:input_dir).validate(xml_dir: :recursive)

          rule(:schema).validate(:existing_dir_or_file)
          rule(:schema).validate(:valid_schema)
        end
      end
    end
  end
end
