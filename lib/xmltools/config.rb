# frozen_string_literal: true

require 'xmltools/loggable'
require 'xmltools/validatable'

module Xmltools
  # This class represents a configuration of the Xmltools application
  # from the default .xmltools.yml file, or from another config file
  # passed in as an argument to the CLI
  class Config
    include AutoInject[:config_validator]
    include Xmltools::Loggable
    include Xmltools::Validatable

    def call(hash = {})
      @hash = hash
      fixup_hash
      valid_data(validated)
    end

    private

    def hash
      @hash ||= {}
    end
    
    def validated
      @validated ||= validate
    end

    def expand_paths
      %i[input_dir schema].each do |key|
        next unless hash.key?(key)

        @hash[key] = File.expand_path(hash[key])
      end
    end
    
    def fixup_hash
      return if hash.empty?

      @hash = hash.transform_keys(&:to_sym)
      expand_paths
    end

    def validate
      config_validator.call(hash)
    end
  end
end
