# frozen_string_literal: true

require 'xmltools/config_contract'
require 'xmltools/loggable'

module Xmltools
  # This class represents a configuration of the Xmltools application
  # from the default .xmltools.yml file, or from another config file
  # passed in as an argument to the CLI
  class Config
    include Xmltools::Loggable
    
    attr_reader :hash
    def initialize(hash = {})
      @hash = hash
      fixup_hash unless @hash.empty?
    end

    def validation_result
      @result ||= validate
    end

    private

    def fixup_hash
      @hash = hash.transform_keys(&:to_sym)
      @hash[:input_dir] = File.expand_path(@hash[:input_dir]) if @hash.key?(:input_dir)
      @hash[:schema] = File.expand_path(@hash[:schema]) if @hash.key?(:input_dir)
    end

    def validate
      contract = ConfigContract.new
      contract.call(
        input_dir: @hash.fetch(:input_dir, ''),
        schema: @hash.fetch(:schema, ''),
        recursive: @hash.fetch(:recursive, false)
      )
    end
  end
end
