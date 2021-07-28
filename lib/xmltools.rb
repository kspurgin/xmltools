# frozen_string_literal: true

require 'xmltools/version'

# standard library
require 'logger'
require 'pathname'

# external gems
require 'active_support'
require 'active_support/core_ext/object/blank'
require 'dry-configurable'
require 'dry/files'
require 'pry'

# Tools for working with XML data
module Xmltools
  extend Dry::Configurable

  setting :input_dir, '', reader: true
  setting :schema, '', reader: true
  setting :recursive, false, reader: true

  def self.setup(config_hash)
    self.config.input_dir = config_hash[:input_dir] if config_hash.key?(:input_dir)
    self.config.schema = config_hash[:schema] if config_hash.key?(:schema)
    self.config.recursive = config_hash[:recursive] if config_hash.key?(:recursive)
  end
  
  Dir.glob("#{__dir__}/**/*").sort.select{ |path| path.match?(/\.rb$/) }.each do |rbfile|
    require rbfile.delete_prefix("#{File.expand_path(__dir__)}/lib/")
  end  
end
