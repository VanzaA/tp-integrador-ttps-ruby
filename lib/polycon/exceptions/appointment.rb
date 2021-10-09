# frozen_string_literal: true

module Polycon
  module Exceptions
    module Appointment
      class AppointmentAlreadyExists < StandardError
        def initialize(msg = 'El turno ya existe')
          super(msg)
        end
      end

      class AppointmentNotExists < StandardError
        def initialize(msg = 'El turno no existe')
          super(msg)
        end
      end
    end
  end
end
