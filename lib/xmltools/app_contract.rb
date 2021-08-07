# frozen_string_literal: true

require 'pathname'
require 'dry-validation'

require 'xmltools/loggable'
require 'xmltools/xml'

module Xmltools
  # Common validation macros shared across the application
  #
  # Specific contracts that use these macros are subclasses of this class
  class AppContract < Dry::Validation::Contract
    include Loggable
    include Xml

    register_macro(:can_create_file) do
      next if value.blank?

      path = files.expand_path(value)
      next if files.exist?(path) && File.writable?(path)

      if files.exist?(path) && !File.writable?(path)
        key.failure("Cannot write to #{key_name}: #{values.data[key_name]}")
        next
      end

      begin
        files.touch(path)
      rescue Dry::Files::Error
        key.failure("Cannot write to #{key_name}: #{values.data[key_name]}")
      end
    end

    register_macro(:existing_dir_or_file) do
      next if value.blank?

      path = files.expand_path(value)
      key.failure("#{key_name} does not exist at #{values.data[key_name]}") unless files.exist?(path)
    end

    register_macro(:populated) do
      msg = "No value for #{key_name} found in config file(s). You must provide a value."
      key.failure(msg) if value.blank?
    end

    register_macro(:valid_schema) do
      next if value.blank?

      begin
        schema_doc(value)
      rescue Xmltools::Xml::InvalidSchemaError
        key.failure("invalid schema at #{value}")
      end
    end

    register_macro(:valid_xpath) do
      next if value.blank?

      begin
        test_doc.xpath(value)
      rescue Nokogiri::XML::XPath::SyntaxError
        key.failure("#{value} is invalid xpath")
      end
    end

    register_macro(:xml_dir) do |macro:|
      recurse = values[macro.args[0]]

      next if value.blank?

      errors = result.errors
      next unless errors.empty? || errors[key_name].empty?

      path = files.expand_path(value)
      if recurse
        key.failure('directory contains no XML') unless dir_has_xml_recursive?(path)
      else
        key.failure('directory contains no XML') unless dir_has_xml_nonrecursive?(path)
      end
    end

    private

    def files
      @files ||= Dry::Files.new
    end
  end
end
