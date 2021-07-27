# frozen_string_literal: true

module Xmltools
  module CLI
    module Commands
      # Command to return version of Xmltools application in CLI
      class Version < Dry::CLI::Command
        desc 'Show Xmltools version'

        def call(*)
          puts "v#{Xmltools::VERSION}"
        end
      end
    end
  end
end
