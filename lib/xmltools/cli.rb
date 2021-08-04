# frozen_string_literal: true

module Xmltools
  # Organizes the code that creates the command line interface for interacting with the
  #   application
  module CLI
    def put_app_options(arr)
      options = Xmltools.config.values
      arr.each{ |opt| puts "  #{opt}: #{options[opt]}" }
    end

    def put_command_examples(prefix)
      puts ''
      examples.each{ |example| puts "#{prefix} #{example}" }
    end

    def put_command_errors(command, result)
      puts "Cannot #{command} due to errors:"
      result.errors.sort_by(&:path).each do |err|
        puts "  ERROR: #{err.path.join(', ')} #{err.text}"
      end
    end
  end
end
