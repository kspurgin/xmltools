# frozen_string_literal: true

require 'nokogiri'
# require 'xmltools'

module Xmltools
  # Mixin methods for working with XML
  module Xml
    class InvalidSchemaError < StandardError; end

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
