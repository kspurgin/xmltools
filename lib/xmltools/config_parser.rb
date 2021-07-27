# frozen_string_literal: true

require 'yaml'
require 'xmltools/loggable'

module Xmltools
  # This class parses a .yml config and returns only valid keys in the
  # hash
  class ConfigParser
    include Xmltools::Loggable
    
    attr_reader :hash
    def initialize(path)
      @path = path
      
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
