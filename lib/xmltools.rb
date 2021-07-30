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

# dev gems
require 'byebug'
require 'pry'
require 'pry-byebug'

# Tools for working with XML data
module Xmltools
  extend Dry::Configurable

  puts 'Loaded Xmltools'

  # Initial configuration settings
  setting :input_dir, reader: true
  setting :schema, reader: true
  setting :recursive, reader: true

  # Require application files
  Dir.glob("#{__dir__}/**/*").sort.select{ |path| path.match?(/\.rb$/) }.each do |rbfile|
    require rbfile.delete_prefix("#{File.expand_path(__dir__)}/lib/")
  end

  # Update configuration settings from given hash
  def self.setup(config_hash)
    config.update(config_hash)
  end
end
