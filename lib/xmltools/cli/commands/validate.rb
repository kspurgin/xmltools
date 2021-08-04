# frozen_string_literal: true

module Xmltools
  module CLI
    module Commands
      # Commands to validate XML
      module Validate
        require 'xmltools/cli/commands/validate/directory'
        require 'xmltools/cli/commands/validate/directory_param_contract'
        require 'xmltools/cli/commands/validate/directory_run_contract'
      end
    end
  end
end
