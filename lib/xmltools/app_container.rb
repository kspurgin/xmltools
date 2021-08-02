require 'dry-container'
require 'dry-auto_inject'

require 'xmltools/xml_directory'

module Xmltools
  class AppContainer
    extend Dry::Container::Mixin
  end

  AppContainer.register(:app_config, -> { Xmltools::Config.new })
  AppContainer.register(:manage_xml_validation, -> { ManageXmlValidation.new })
  AppContainer.register(:xml_input, -> { Xmltools::XmlDirectory.new })

  # validation contracts
  AppContainer.register(:config_validator, -> { Xmltools::ConfigContract.new })
  
  AutoInject = Dry::AutoInject(AppContainer)
end
