module Polycon
  module Exceptions
    module Professional
      class ProfessionalExist < StandardError
        def initialize(msg="El professional ya existe")
          super(msg)
        end
      end

      class ProfessionalNotFound < StandardError
        def initialize(msg="No se encontro el profesional")
          super(msg)
        end
      end
    end
  end
end