# frozen_string_literal: true

require 'logger'

module Xmltools
  # Mixin module enabling a single Logger instance for the application
  module Loggable
    # Mixin method to write to logger
    def logger
      Loggable.logger
    end

    # Global, memoized, lazy initialized instance of a logger
    def self.logger
      @logger ||= Logger.new($stdout)
    end
  end
end
