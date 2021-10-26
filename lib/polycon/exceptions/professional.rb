# frozen_string_literal: true

module Polycon
  module Exceptions
    module Professional
      class Exist < StandardError
        def initialize(msg = 'El professional ya existe')
          super(msg)
        end
      end

      class NotFound < StandardError
        def initialize(msg = 'No se encontro el profesional')
          super(msg)
        end
      end

      class HasAppoinments < StandardError
        def initialize(msg = 'El profesional tiene turnos y no puede ser')
          super(msg)
        end
      end
    end
  end
end
