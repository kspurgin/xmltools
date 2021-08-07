# frozen_string_literal: true

module RSpec
  module Support
    # Methods to support testing
    module Helpers
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

      def extra_setting_config
        <<~CONFIG
          input_dir: #{files.join(fixtures_dir, 'xml')}
          xzy: false
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
