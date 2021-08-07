# frozen_string_literal: true

require 'support/fixtures/configs'

module RSpec
  module Support
    # Methods to support testing
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

      # Compares key/values present in given hash against the values of those settings in Xmltools.config.
      #   Does not require the given hash to include all settings available in Xmltools.config in order to
      #   return true.
      # @return [TrueClass] if values for the settings match
      def compare_config(hash)
        hash.each do |setting, value|
          return false unless Xmltools.send(setting) == value
        end
        true
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
    end
  end
end

RSpec.configure do |config|
  config.include(RSpec::Support::Helpers)
end
