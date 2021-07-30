# frozen_string_literal: true

require 'pathname'

require 'xmltools'

module Xmltools
  # Manages the validation and reporting of validation results for an XMLDirectory
  class XmlDirectory
    def initialize
      @path = Pathname.new(Xmltools.input_dir)
    end
    
    def create
      Xmltools.recursive ? XmlDirectoryRecursive.new : XmlDirectory.new
    end

    def files
      @path.children.select{ |child| child.extname == '.xml' }
    end
  end
end
