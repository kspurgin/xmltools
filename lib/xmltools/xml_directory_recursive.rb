# frozen_string_literal: true

require 'xmltools/xml_directory'

module Xmltools
  # Manages the validation and reporting of validation results for an XMLDirectory
  class XmlDirectoryRecursive < Xmltools::XmlDirectory
    def files
      Dir.glob("#{@path}/**/*")
        .sort
        .select{ |file| File.extname(file) == '.xml' }
        .map{ |path| Pathname.new(path) }
    end
  end
end
