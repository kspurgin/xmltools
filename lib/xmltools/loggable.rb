require 'logger'

module Xmltools
  module Loggable
    # Mixin method to write to logger
    def logger
      Loggable.logger
    end

    # Global, memoized, lazy initialized instance of a logger
    def self.logger
      @logger ||= Logger.new(STDOUT)
    end
  end
end
