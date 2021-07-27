# frozen_string_literal: true

require 'pathname'
require 'dry/files'
require 'dry-validation'

require 'xmltools'

module Xmltools
  # Common validation macros shared across the application
  class AppContract < Dry::Validation::Contract
    register_macro(:existing_dir) do
      next if value.empty?

      path = files.expand_path(value)
      key.failure('directory does not exist') unless files.exist?(path)
    end
    
    register_macro(:xml_dir) do
      keys = values.keys
      dir_key = keys[0]
      dir = values[dir_key]
      recurse_key = keys[1]
      recurse = values[recurse_key]

      next if value.empty?

      path = files.expand_path(dir)

      if !dir_has_xml?(path, recurse)
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
