# frozen_string_literal: true

require 'dry-validation'

require 'xmltools'
require 'xmltools/app_contract'
require 'xmltools/xml'

module Xmltools
  module CLI
    module Commands
      # Validations for Validate CLI command
      class ValidateContract < AppContract
        include Xml
        schema do
          optional(:input_dir).value(:string)
          optional(:schema).value(:string)
          optional(:recursive).value(:bool)
        end

        rule(:input_dir).validate(:existing_dir_or_file)
        rule(:input_dir).validate(xml_dir: :recursive)

        rule(:schema).validate(:existing_dir_or_file)
        rule(:schema) do
          begin
            schema_doc(value)
          rescue Xmltools::Xml::InvalidSchemaError
            key.failure("invalid schema at #{value}")
          end
        end
      end
    end
  end
end
