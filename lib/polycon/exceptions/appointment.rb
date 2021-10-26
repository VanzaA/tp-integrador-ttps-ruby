# frozen_string_literal: true

module Polycon
  module Exceptions
    module Appointment
      class AlreadyExists < StandardError
        def initialize(msg = 'El turno ya existe')
          super(msg)
        end
      end

      class NotExists < StandardError
        def initialize(msg = 'El turno no existe')
          super(msg)
        end
      end
    end
  end
end
