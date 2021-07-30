# frozen_string_literal: true

module Xmltools
  # Manages the validation and reporting of validation results for an XMLDirectory
  class XmlValidationManager
    def call
      @dir = Xmltools::XmlDirectory.new(Xmltools.input_dir)
    end
  end
end
