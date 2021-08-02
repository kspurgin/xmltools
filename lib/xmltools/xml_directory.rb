# frozen_string_literal: true

require 'pathname'

require 'xmltools'

module Xmltools
  # Returns Pathnames of XML files in a given directory
  class XmlDirectory
    def call
      @path = Pathname.new(Xmltools.input_dir)
      Xmltools.recursive ? recursive_files : files
    end

    private

    def files
      @path.children.select{ |child| child.extname == '.xml' }
    end

    def recursive_files
      Dir.glob("#{@path}/**/*")
         .sort
         .select{ |file| File.extname(file) == '.xml' }
         .map{ |path| Pathname.new(path) }
    end
  end
end
