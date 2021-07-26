# frozen_string_literal: true

require 'dry/cli'

module Xmltools
  module CLI
    module Commands
      # Command to return version of Xmltools application in CLI
      class Version < Dry::CLI::Command
        desc 'Print version'

        def call(*)
          puts Xmltools::VERSION
        end
      end
    end
  end
end
