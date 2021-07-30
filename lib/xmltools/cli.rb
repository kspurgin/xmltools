# frozen_string_literal: true

module Xmltools
  # Organizes the code that creates the command line interface for interacting with the
  #   application
  module CLI
    def put_app_options(arr)
      options = Xmltools.config.values
      arr.each{ |opt| puts "  #{opt}: #{options[opt]}" }
    end
  end
end
