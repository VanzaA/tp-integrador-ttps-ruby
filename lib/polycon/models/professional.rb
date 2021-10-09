# frozen_string_literal: true

module Polycon
  module Models
    class Professional
      def self.create(name)
        if Polycon::Helpers::FileSystem.folder_exist?(name)
          raise Polycon::Exceptions::Professional::ProfessionalExist, "El profesional #{name} ya existe"
        end

        Polycon::Helpers::FileSystem.create_folder(name)
        new(name)
      end

      def self.list
        # si no existe la carpeta .polycon en el home, no hay profesionales
        # ToDo: Ver de hacer parametrizable el lugar donde se guardan los datos
        unless Polycon::Helpers::FileSystem.folder_exist?('')
          raise Polycon::Exceptions::Professional::ProfessionalNotFound, 'No existen profesionales'
        end

        professionals = Polycon::Helpers::FileSystem.list_folders
        if professionals.empty?
          raise raise Polycon::Exceptions::Professional::ProfessionalNotFound, 'No existen profesionales'
        end

        professionals
      end

      def self.remove(name)
        unless Polycon::Helpers::FileSystem.folder_exist?(name)
          raise Polycon::Exceptions::Professional::ProfessionalNotFound, "El profesional #{name} no existe"
        end

        appointments = Polycon::Helpers::FileSystem.list_files(name)
        unless appointments.empty?
          raise Polycon::Exceptions::Professional::ProfessionalHasAppoinments,
                "El profesional #{name} no puede ser eliminado porque tiene #{appointments.size} turno(s) asignados"
        end

        Polycon::Helpers::FileSystem.remove_file(name)
      end

      def self.rename(old_name, new_name)
        unless Polycon::Helpers::FileSystem.folder_exist?(old_name)
          raise Polycon::Exceptions::Professional::ProfessionalNotFound, "El profesional #{old_name} no existe"
        end
        if Polycon::Helpers::FileSystem.folder_exist?(new_name)
          raise Polycon::Exceptions::Professional::ProfessionalExist, "El profesional #{new_name} ya existe"
        end

        Polycon::Helpers::FileSystem.rename(old_name, new_name)
      end
    end
  end
end
