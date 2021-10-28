# frozen_string_literal: true

module Polycon
  module Models
    class Professional
      def self.create(name)
        validate_professional_existance(name)

        Polycon::Helpers::FileSystem.create_folder(name)
      end

      def self.list
        # si no existe la carpeta .polycon en el home, no hay profesionales
        # ToDo: Ver de hacer parametrizable el lugar donde se guardan los datos
        unless Polycon::Helpers::FileSystem.folder_exist?('')
          raise Polycon::Exceptions::Professional::NotFound, 'No existen profesionales'
        end

        professionals = Polycon::Helpers::FileSystem.list_folders
        if professionals.empty?
          raise raise Polycon::Exceptions::Professional::NotFound, 'No existen profesionales'
        end

        professionals
      end

      def self.remove(name)
        validate_professional_not_exist(name)

        appointments = Polycon::Helpers::FileSystem.list_files(name)
        unless appointments.empty?
          raise Polycon::Exceptions::Professional::HasAppoinments,
                "El profesional #{name} no puede ser eliminado porque tiene #{appointments.size} turno(s) asignados"
        end

        Polycon::Helpers::FileSystem.remove_file(name)
      end

      def self.rename(old_name, new_name)
        validate_professional_not_exist(old_name)
        validate_professional_existance(new_name)

        Polycon::Helpers::FileSystem.rename(old_name, new_name)
      end

      def self.list_or_filter_by_name(professional)
        unless professional.empty?
          validate_professional_not_exist(professional)
          return [professional]
        end
        return list

      end

      ###############
      # validations #
      ###############

      def self.validate_professional_not_exist(name)
        unless Polycon::Helpers::FileSystem.folder_exist?(name)
          raise Polycon::Exceptions::Professional::NotFound, "El profesional #{name} no existe"
        end

        true
      end

      def self.validate_professional_existance(name)
        if Polycon::Helpers::FileSystem.folder_exist?(name)
          raise Polycon::Exceptions::Professional::Exist, "El profesional #{name} ya existe"
        end

        true
      end
    end
  end
end
