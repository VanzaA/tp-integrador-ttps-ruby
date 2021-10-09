require 'date'
module Polycon
  module Models
    class Appointment
      def self.create(date, professional, name, surname, phone, notes = nil)
        validate_professional_not_exist(professional)
        validate_date(date)
        validate_appointment_existance(professional, date)

        Polycon::Helpers::FileSystem.create_file(professional, name)
        content = [name, surname, phone, notes]
        Polycon::Helpers::FileSystem.insert_content(professional, date, content)
      end

      def self.show(date, professional)
        validate_professional_not_exist(professional)
        validate_appointment_not_exist(professional, date)

        get_file_content(professional, date)
      end

      def self.remove(date, professional)
        validate_professional_not_exist(professional)
        validate_appointment_not_exist(professional, date)

        Polycon::Helpers::FileSystem.remove_file(professional, date)
      end

      def self.remove_all(professional)
        validate_professional_not_exist(professional)
        appointments = Polycon::Helpers::FileSystem.list_files(professional)

        if appointments.empty?
          raise Polycon::Exceptions::Appointment::AppointmentNotExists,
                "El profesional #{professional} no posee ningun turno"
        end
        appointments.each { |date| Polycon::Helpers::FileSystem.remove_file(professional, date) }
      end

      def self.list(professional)
        validate_professional_not_exist(professional)
        appointments = Polycon::Helpers::FileSystem.list_files(professional)

        if appointments.empty?
          raise Polycon::Exceptions::Appointment::AppointmentNotExists,
                "El profesional #{professional} no posee ningun turno"
        end
        appointments
      end

      def self.reschedule(old_date, new_date, professional)
        validate_professional_not_exist(professional)
        validate_appointment_not_exist(professional, old_date)
        validate_appointment_existance(professional, new_date)

        Polycon::Helpers::FileSystem.rename_file(professional, old_date, new_date)
      end

      def self.edit(date, professional, **options)
        validate_professional_not_exist(professional)
        validate_appointment_not_exist(professional, date)

        content = get_file_content(professional, date).merge(options)
        content_as_arr = [content[:name], content[:surname], content[:phone], content[:notes]]
        Polycon::Helpers::FileSystem.insert_content(professional, date, content_as_arr)
      end

      def self.get_file_content(professional, date)
        file_data = Polycon::Helpers::FileSystem.read_file(professional, date)

        {
          professional: professional,
          date: date,
          name: file_data[0],
          surname: file_data[1],
          phone: file_data[2],
          notes: file_data[3]
        }
      end

      ###############
      # validations #
      ###############
      def self.validate_professional_not_exist(professional)
        unless Polycon::Helpers::FileSystem.folder_exist?(professional)
          raise Polycon::Exceptions::Professional::ProfessionalNotFound, "El profesional #{professional} no existe"
        end

        true
      end

      def self.validate_date(date)
        parsed_date = DateTime.parse(date)
        if parsed_date < DateTime.now
          raise Polycon::Exceptions::Date::InvalidDate, "La fecha #{date} es menor a la fecha actual"
        end

        true
      end

      def self.validate_appointment_existance(professional, date)
        if Polycon::Helpers::FileSystem.file_exist?(professional, date)
          raise Polycon::Exceptions::Appointment::AppointmentAlreadyExists,
                "Ya se encuentra un turno para el profesional #{professional} a la hora #{date}"
        end

        true
      end

      def self.validate_appointment_not_exist(professional, date)
        unless Polycon::Helpers::FileSystem.file_exist?(professional, date)
          raise Polycon::Exceptions::Appointment::AppointmentNotExists,
                "El turno para el professional #{professional} en la fecha #{date} no existe"
        end

        true
      end
    end
  end
end
