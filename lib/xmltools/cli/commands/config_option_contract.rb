# frozen_string_literal: true

require 'dry-validation'

require 'xmltools/app_contract'

module Xmltools
  module CLI
    module Commands
      # Validations for the config option passed into CLI commands
      class ConfigOptionContract < AppContract
        schema do
          required(:config).value(:string)
        end

        rule(:config).validate(:existing_dir_or_file)
      end
    end
  end
end
