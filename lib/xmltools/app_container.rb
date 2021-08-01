require 'dry-container'
require 'dry-auto_inject'

require 'xmltools/xml_directory'

module Xmltools
  class AppContainer
    extend Dry::Container::Mixin
  end

  AppContainer.register(:xml_input, -> { Xmltools::XmlDirectory.new })
  AppContainer.register(:manage_xml_validation, -> { ManageXmlValidation.new })

  AutoInject = Dry::AutoInject(AppContainer)
end
