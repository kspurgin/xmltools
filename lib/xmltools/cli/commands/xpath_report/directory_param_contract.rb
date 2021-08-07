# frozen_string_literal: true

require 'dry-validation'

require 'xmltools/app_contract'

module Xmltools
  module CLI
    module Commands
      module XpathReport
        # Validations for Validate CLI command parameters
        class DirectoryParamContract < AppContract
          schema do
            optional(:input_dir).value(:string)
            optional(:xpath).value(:string)
            optional(:report_path).value(:string)
          end

          rule(:input_dir).validate(:existing_dir_or_file)
          rule(:input_dir).validate(xml_dir: :recursive)

          rule(:xpath).validate(:valid_xpath)

          rule(:report_path).validate(:can_create_file)
        end
      end
    end
  end
end
