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
        path.sub(%r{^.*/xmltools}, '/xmltools')
      end

      def config_file(config)
        path = files.join(fixtures_dir, 'configs', 'config.yml')
        return path if files.exist?(path) && files.read(path) == config

        files.write(path, config)
        path
      end

      def config_reset
        puts 'Resetting config'
        Xmltools.reset_config
        Xmltools::ConfigLoader.new.call(config_file(ok_config))
      end

      def fixtures_dir
        home = File.realpath(File.join(File.dirname(__FILE__), '..', '..'))
        File.join(home, 'spec', 'support', 'fixtures')
      end

      def invalid_schema_config
        <<~CONFIG
          input_dir: #{files.join(fixtures_dir, 'xml')}
          recursive: false
          schema: #{files.join(fixtures_dir, 'xsd', 'mods_schema_invalid.xsd')}
        CONFIG
      end

      def ok_config
        <<~CONFIG
          input_dir: #{files.join(fixtures_dir, 'xml')}
          recursive: false
          schema: #{files.join(fixtures_dir, 'xsd', 'mods_schema.xsd')}
        CONFIG
      end

      def ok_config_recursive
        <<~CONFIG
          input_dir: #{files.join(fixtures_dir, 'xml2')}
          recursive: true
          schema: #{files.join(fixtures_dir, 'xsd', 'mods_schema2.xsd')}
        CONFIG
      end

      def ok_tmp_config
        <<~CONFIG
          input_dir: #{files.join(fixtures_dir, 'tmpxml')}
          recursive: false
          schema: #{files.join(fixtures_dir, 'xsd', 'mods_schema.xsd')}
        CONFIG
      end

      def only_recursive_config
        <<~CONFIG
          recursive: true
        CONFIG
      end
    end
  end
end

RSpec.configure do |config|
  config.include(RSpec::Support::Helpers)
end
