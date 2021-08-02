# frozen_string_literal: true

require 'yaml'

require 'xmltools/config'
require 'xmltools/loggable'

module Xmltools
  # This class manages loading the a configuration file of the Xmltools application
  # from the default .xmltools.yml file, or from another config file
  # passed in as an argument to the CLI, and creating a config object from it
  class ConfigLoader
    include Xmltools::Loggable

    class FileUnparseableError < StandardError; end

    DOTFILE = '.xmltools.yml'
    XMLTOOLS_HOME = File.realpath(File.join(File.dirname(__FILE__), '..', '..'))
    DEFAULT_FILE = File.join(XMLTOOLS_HOME, DOTFILE)

    attr_reader :path

    def initialize(config_path = DEFAULT_FILE)
      @hash = {}
      @path = File.expand_path(config_path)
      file_missing? ? handle_missing_file : hash_from_yaml
      Xmltools.setup(Xmltools::Config.new.call(@hash))
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
    end

    def hash_from_yaml
      yaml = File.read(@path)
      empty_yaml = yaml.empty?
      logger.warn("Empty config file at #{path}") if empty_yaml
      return if empty_yaml

      parse_yaml(yaml)
    end

    def parse_yaml(yaml)
      result = YAML.safe_load(yaml)
    rescue Psych::SyntaxError => e
      logger.warn("Invalid config file at #{path}. Cannot parse the YAML because: #{e.message}")
    else
      @hash = result
    end
  end
end
