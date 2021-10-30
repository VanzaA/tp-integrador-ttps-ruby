require 'date'
module Polycon
  module Models
    class Appointment
      attr_accessor :date, :professional, :time, :filename
      START_OF_TABLE = '8'
      END_OF_TABLE = '20'
      RANGE_MINUTES = 15

      def initialize(date, time, professional, filename)
        self.date = date
        self.time = time
        self.professional = professional
        self.filename = filename
      end

      def pacient_full_name
        data = Polycon::Helpers::FileSystem.read_file(self.professional, self.filename)

        "#{data[1]}, #{data[0]}"
      end

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
          raise Polycon::Exceptions::Appointment::NotExists,
                "El profesional #{professional} no posee ningun turno"
        end
        appointments.each { |date| Polycon::Helpers::FileSystem.remove_file(professional, date) }
      end

      def self.list(professional)
        validate_professional_not_exist(professional)
        appointments = Polycon::Helpers::FileSystem.list_files(professional)

        if appointments.empty?
          raise Polycon::Exceptions::Appointment::NotExists,
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

      def self.list_by_date_and_professional(date, fullweek, professionals)
        parsed_date = Date.parse(date)
        begining_of_week = parsed_date - parsed_date.wday
        dates = fullweek ? (0...7).to_a.map { |day| (begining_of_week + day)} : [parsed_date]

        appointments = dates.map do |day|
          files = Polycon::Helpers::FileSystem.get_files_by_date_and_professionals(day.to_s, professionals)
          instances = generate_appointments_instances(files)
          appointments_formatteds = format_appointments_for_table(instances)

          appointments_formatteds
        end

        empty_days = appointments.all? do |appointments_for_day|
          appointments_for_day.all? { |appointment| appointment.empty? }
        end

        if empty_days
          raise Polycon::Exceptions::Appointment::NotExists, "No hay turnos registrados en esa fecha"
        end

        { days: dates, appointments: appointments }
      end

      def self.generate_appointments_instances(files)
        files.flat_map do |item|
          item.values[0].map do |appointment|
            parsed_date = DateTime.parse(File.basename(appointment, ".paf"))
            date = parsed_date.to_date.to_s
            time = parsed_date.strftime("%H:%M")
            self.new(date, time, item.keys[0], appointment)
          end
        end
      end

      def self.format_appointments_for_table(appointments)
        (START_OF_TABLE..END_OF_TABLE).flat_map do |hour|
          (0..3).map do |min|
            appointments.select{|appointment| appointment.time.include?("#{hour}:#{min*RANGE_MINUTES}")}
          end
        end
      end

      ###############
      # validations #
      ###############
      def self.validate_professional_not_exist(professional)
        unless Polycon::Helpers::FileSystem.folder_exist?(professional)
          raise Polycon::Exceptions::Professional::NotFound, "El profesional #{professional} no existe"
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
          raise Polycon::Exceptions::Appointment::AlreadyExists,
                "Ya se encuentra un turno para el profesional #{professional} a la hora #{date}"
        end

        true
      end

      def self.validate_appointment_not_exist(professional, date)
        unless Polycon::Helpers::FileSystem.file_exist?(professional, date)
          raise Polycon::Exceptions::Appointment::NotExists,
                "El turno para el professional #{professional} en la fecha #{date} no existe"
        end

        true
      end
    end
  end
end
