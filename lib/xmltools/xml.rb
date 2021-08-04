# frozen_string_literal: true

require 'nokogiri'
# require 'xmltools'

module Xmltools
  # Mixin methods for working with XML
  module Xml
    # Exception raised if XML schema cannot be read
    class InvalidSchemaError < StandardError; end

    def dir_has_xml_nonrecursive?(path)
      pathname = Pathname.new(path)
      xml = pathname.children(false).select{ |child| child.extname == '.xml' }
      return true unless xml.empty?

      false
    end

    def dir_has_xml_recursive?(path)
      pathname = "#{path}/**/*"
      xml = Dir.glob(pathname).select{ |fn| File.extname(fn) == '.xml' }
      return true unless xml.empty?

      false
    end

    def xml_files
      @xml_files ||= Dry::Files.new
    end

    def schema_doc(path)
      Nokogiri::XML::Schema(xml_files.read(path))
    rescue Nokogiri::XML::SyntaxError => e
      raise InvalidSchemaError, e.message
    end
  end
end
