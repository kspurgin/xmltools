# frozen_string_literal: true

require 'bundler/setup'
require 'dry/configurable/test_interface'
require 'dry/container/stub'

require 'support/helpers'
require 'xmltools'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

module Xmltools
  enable_test_interface
end
