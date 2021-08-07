# frozen_string_literal: true

require 'nokogiri'
# require 'xmltools'

module Xmltools
  # Mixin methods for working with XML
  module Xml
    # Exception raised if XML schema cannot be read
    class InvalidSchemaError < StandardError; end

    # @return [TrueClass] if given directory contains one or more file with .xml file extension
    # @return [FalseClass] otherwise
    def dir_has_xml_nonrecursive?(path)
      pathname = Pathname.new(path)
      xml = pathname.children(false).select{ |child| child.extname == '.xml' }
      return true unless xml.empty?

      false
    end
    private :dir_has_xml_nonrecursive?

    # @return [TrueClass] if given directory, traversed recursively, contains one or more file
    #   with .xml file extension
    # @return [FalseClass] otherwise
    def dir_has_xml_recursive?(path)
      pathname = "#{path}/**/*"
      xml = Dir.glob(pathname).select{ |fn| File.extname(fn) == '.xml' }
      return true unless xml.empty?

      false
    end
    private :dir_has_xml_recursive?

    # @return [Dry::Files] a [dry-files object](https://dry-rb.org/gems/dry-files/0.1/)
    def xml_files
      @xml_files ||= Dry::Files.new
    end
    private :xml_files

    # @raise [Xmltools::InvalidSchemaError] if given schema cannot be read
    def schema_doc(path)
      Nokogiri::XML::Schema(xml_files.read(path))
    rescue Nokogiri::XML::SyntaxError => e
      raise InvalidSchemaError, e.message
    end
    private :schema_doc

    # @return [Nokogiri::XML::Document] a [Nokogiri XML document](https://nokogiri.org/rdoc/Nokogiri/XML/Document.html)
    #   for use in running xpath validations
    def test_doc
      Nokogiri::XML('<root><aliens><alien><name>Alf</name></alien></aliens></root>')
    end
    private :test_doc
  end
end
