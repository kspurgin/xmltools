# frozen_string_literal: true

require 'dry/cli'

require 'xmltools/cli/commands/version'
require 'xmltools/cli/commands/validate'

module Xmltools
  module CLI
    # Registry of commands for CLI
    module Commands
      extend Dry::CLI::Registry

      register 'version', Version, aliases: ['v', '-v', '--version']
      register 'validate' do |prefix|
        prefix.register 'directory', Validate::Directory
        prefix.register 'file', Validate::File
      end
    end
  end
end
