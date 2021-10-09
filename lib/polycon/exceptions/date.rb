# frozen_string_literal: true

module Polycon
  module Exceptions
    module Date
      class InvalidDate < StandardError
        def initialize(msg = 'La fecha es invalida')
          super(msg)
        end
      end
    end
  end
end
