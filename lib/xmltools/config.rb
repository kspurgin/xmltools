# frozen_string_literal: true

require 'xmltools/config_contract'
require 'xmltools/loggable'

module Xmltools
  # This class represents a configuration of the Xmltools application
  # from the default .xmltools.yml file, or from another config file
  # passed in as an argument to the CLI
  class Config
    include Xmltools::Loggable
    
    attr_reader :orig, :hash
    def initialize(hash = {})
      @orig = hash
      fixup_hash unless @orig.empty?
      if validation_result.success?
        @hash = @orig
        return
      end
      @hash = valid_config_data
    end

    def validation_result
      @result ||= validate
    end

    private

    def valid_config_data
      hash = validation_result.values.data
      validation_result.errors.to_h.keys.each do |key|
        hash.delete(key)
      end
      hash
    end
    
    def fixup_hash
      @orig = @orig.transform_keys(&:to_sym)
      @orig[:input_dir] = File.expand_path(@orig[:input_dir]) if @orig.key?(:input_dir)
      @orig[:schema] = File.expand_path(@orig[:schema]) if @orig.key?(:input_dir)
    end

    def validate
      contract = ConfigContract.new
      contract.call(
        input_dir: @orig.fetch(:input_dir, ''),
        schema: @orig.fetch(:schema, ''),
        recursive: @orig.fetch(:recursive, false)
      )
    end
  end
end
