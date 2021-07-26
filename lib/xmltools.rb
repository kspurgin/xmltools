# frozen_string_literal: true

require 'xmltools/version'

require 'active_support'
require 'active_support/core_ext/object/blank'
require 'pry'

# Tools for working with XML data
module Xmltools
  Dir.glob("#{__dir__}/**/*").sort.select{ |path| path.match?(/\.rb$/) }.each do |rbfile|
    require rbfile.delete_prefix("#{File.expand_path(__dir__)}/lib/")
  end
end
