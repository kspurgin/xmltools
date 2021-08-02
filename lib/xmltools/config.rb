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
      @hash = fixup(hash)
      valid_data(validated)
    end

    private

    def validated
      @validated ||= validate
    end

    def fixup(hash)
      return hash if hash.empty?

      new_hash = hash.transform_keys(&:to_sym)
      %i[input_dir schema].each do |key|
        next unless new_hash.key?(key)

        new_hash[key] = File.expand_path(new_hash[key])
      end
      new_hash
    end

    def validate
      config_validator.call(@hash)
    end
  end
end
