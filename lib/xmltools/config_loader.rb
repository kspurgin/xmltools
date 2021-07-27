# frozen_string_literal: true

require 'xmltools/loggable'

module Xmltools
  # This class represents the configuration of the Xmltools application
  # from the default .xmltools.yml file, or from another config file
  # passed in as an argument to the CLI
  class ConfigLoader
    include Xmltools::Loggable
    
    class FileUnparseableError < StandardError; end
    
    DOTFILE = '.xmltools.yml'
    XMLTOOLS_HOME = File.realpath(File.join(File.dirname(__FILE__), '..', '..'))
    DEFAULT_FILE = File.join(XMLTOOLS_HOME, DOTFILE)

    attr_reader :path, :hash
    def initialize(config_path = DEFAULT_FILE)
      @path = config_path

      if file_missing?
        handle_missing_file
        return
      end

      
    end
    
    private

    def default_file
      DEFAULT_FILE
    end

    def file_missing?
      !File.exist?(@path)
    end

    def handle_missing_file
      logger.warn("Config file does not exist at #{@path}")
      @hash = {}
    end
  end
end
