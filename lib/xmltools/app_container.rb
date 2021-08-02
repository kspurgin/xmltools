# frozen_string_literal: true

require 'dry-container'
require 'dry-auto_inject'
require 'xmltools'

# rubocop:disable Style/Documentation
# This top-level module is documented in lib/xmltools
module Xmltools
  # dry-container to manage inversion of control
  class AppContainer
    extend Dry::Container::Mixin
  end

  AppContainer.register(:app_config, ->{ Xmltools::Config.new })
  AppContainer.register(:config_loader, ->{ Xmltools::ConfigLoader.new })
  AppContainer.register(:manage_xml_validation, ->{ ManageXmlValidation.new })
  AppContainer.register(:xml_input, ->{ Xmltools::XmlDirectory.new })

  # validation contracts
  AppContainer.register(:config_validator, ->{ Xmltools::ConfigContract.new })
  AppContainer.namespace('cli') do
    namespace('commands') do
      register('validate_params_validator', ->{ Xmltools::CLI::Commands::ValidateContract.new })
      register('validate_run_validator', ->{ Xmltools::CLI::Commands::ValidateRunContract.new })
    end
  end

  AutoInject = Dry::AutoInject(AppContainer)
end
# rubocop:enable Style/Documentation
