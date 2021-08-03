# frozen_string_literal: true

require 'dry/cli'

# require 'xmltools'
# require 'xmltools/config_loader'
require 'xmltools/cli/commands/validate'
require 'xmltools/cli/commands/version'

module Xmltools
  module CLI
    # Registry of commands for CLI
    module Commands
      extend Dry::CLI::Registry

      register 'version', Version, aliases: ['v', '-v', '--version']
      register 'validate', Validate
    end
  end
end
