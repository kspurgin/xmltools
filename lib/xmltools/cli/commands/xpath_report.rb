# frozen_string_literal: true

module Xmltools
  module CLI
    module Commands
      # Commands to report on xpath occurrences in XML
      module XpathReport
        require 'xmltools/cli/commands/xpath_report/directory'
        require 'xmltools/cli/commands/xpath_report/directory_param_contract'
        require 'xmltools/cli/commands/xpath_report/directory_run_contract'
      end
    end
  end
end
