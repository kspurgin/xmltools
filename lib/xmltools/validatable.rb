# frozen_string_literal: true

module Xmltools
  # Mixin module for post-processing dry-validation contract results
  module Validatable
    def valid_data(result)
      hash = result.values.data
      result.errors.to_h.each_key do |key|
        hash.delete(key)
      end
      hash
    end
  end
end
