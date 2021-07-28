# frozen_string_literal: true

require 'pathname'
require 'dry-validation'

require 'xmltools'
require 'xmltools/xml'

module Xmltools
  # Common validation macros shared across the application
  class AppContract < Dry::Validation::Contract
    include Xml
    
    register_macro(:existing_dir_or_file) do
      next if value.empty?

      path = files.expand_path(value)
      key.failure("#{key_name} does not exist at #{values.data[key_name]}") unless files.exist?(path)
    end

    register_macro(:valid_schema) do
      begin
        schema_doc(value)
      rescue Xmltools::Xml::InvalidSchemaError
        key.failure("invalid schema at #{value}")
      end
    end

    register_macro(:xml_dir) do |macro:|
      recurse = values[macro.args[0]]

      next if value.empty?

      errors = result.errors
      next unless errors.empty? || errors[key_name].empty?

      if !dir_has_xml?(files.expand_path(value), recurse)
        key.failure('directory contains no XML')
        next
      end
    end

    private

    def dir_has_xml?(path, recurse)
      recurse ? dir_has_xml_recursive?(path) : dir_has_xml_nonrecursive?(path) 
    end

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

    def files
      @files ||= Dry::Files.new
    end
  end
end
