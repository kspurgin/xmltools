# frozen_string_literal: true

require 'dry-validation'

require 'xmltools'
require 'xmltools/app_contract'

module Xmltools
  # Validations for Validate CLI command
  class ConfigContract < AppContract
    schema do
      optional(:input_dir).value(:string)
      optional(:schema).value(:string)
      optional(:recursive).value(:bool)
      optional(:report_path).value(:string)
      optional(:xpath).value(:string)
    end

    rule(:input_dir).validate(:existing_dir_or_file)
    rule(:input_dir).validate(xml_dir: :recursive)

    rule(:schema).validate(:existing_dir_or_file)
    rule(:schema).validate(:valid_schema)

    rule(:report_path).validate(:can_create_file)

    rule(:xpath).validate(:valid_xpath)
  end
end
