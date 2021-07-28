# frozen_string_literal: true

module RSpec
  module Support
    module Helpers
      def files
        @files ||= Dry::Files.new
      end
      
      def capture_error
        require 'stringio'
        error = StringIO.new
        original_stderr = $stderr
        $stderr = error
        yield
        error.string
      rescue SystemExit
        error.string
      ensure
        $stderr = original_stderr
      end

      def capture_output
        require 'stringio'
        output = StringIO.new
        original_stdout = $stdout
        $stdout = output
        yield
        output.string
      rescue SystemExit
        output.string
      ensure
        $stdout = original_stdout
      end

      def clean_test_path(path)
        path.sub(/^.*\/xmltools/, '/xmltools')
      end

      def fixtures_dir
        home = File.realpath(File.join(File.dirname(__FILE__), '..', '..'))
        File.join(home, 'spec', 'support', 'fixtures') 
      end

      def ok_config
        config = <<~CONFIG
        input_dir: #{files.join(fixtures_dir, 'xml')}
        recursive: false
        schema: #{files.join(fixtures_dir, 'xsd', 'mods_schema.xsd')}
        CONFIG
        config
      end

      def ok_config_recursive
        config = <<~CONFIG
        input_dir: #{files.join(fixtures_dir, 'xml')}
        recursive: true
        schema: #{files.join(fixtures_dir, 'xsd', 'mods_schema.xsd')}
        CONFIG
        config
      end

      def config_file(config)
        path = files.join( fixtures_dir, 'configs', 'config.yml' )
        return path if files.exist?(path) && files.read(path) == config

        files.write(path, config)
        path
      end
    end
  end
end

RSpec.configure do |config|
  config.include(RSpec::Support::Helpers)
end
