# frozen_string_literal: true

require 'xmltools/xml'

module Xmltools
  # Manages the validation and reporting of validation results for an XMLDirectory
  class ManageXmlValidation
    include AutoInject[:xml_input]
    include Xmltools::Xml

    def call
      xml_input.call.each do |file|
        puts file.to_s
      end
      self
    end
  end
end
