# frozen_string_literal: true

module Polycon
  module Commands
    module Appointments
      class Create < Dry::CLI::Command
        require 'erb'
        desc 'Create an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'
        option :name, required: true, desc: "Patient's name"
        option :surname, required: true, desc: "Patient's surname"
        option :phone, required: true, desc: "Patient's phone number"
        option :notes, required: false, desc: 'Additional notes for appointment'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" --name=Carlos --surname=Carlosi --phone=2213334567'
        ]

        def call(date:, professional:, name:, surname:, phone:, notes: nil)
          Polycon::Models::Appointment.create(date, professional, name, surname, phone, notes)
          puts 'Se creo el turno correctamente'
        rescue Polycon::Exceptions::Professional::NotFound, Polycon::Exceptions::Date::InvalidDate,
               Polycon::Exceptions::Appointment::AlreadyExists => e
          puts e.message
        rescue Date::Error
          puts 'EL formato de la fecha es invalido'
        end
      end

      class Show < Dry::CLI::Command
        desc 'Show details for an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" # Shows information for the appointment with Alma Estevez on the specified date and time'
        ]

        def call(date:, professional:)
          translation_keys = {
            "name": 'Nombre',
            "surname": 'Apellido',
            "notes": 'Notas',
            "phone": 'Telefono',
            "professional": 'Profesional',
            "date": 'Fecha'
          }

          Polycon::Models::Appointment.show(date, professional).each do |key, value|
            puts "#{translation_keys[key]}: #{value}" if value
          end
        rescue Polycon::Exceptions::Professional::NotFound,
               Polycon::Exceptions::Appointment::NotExists => e
          warn e.message
        end
      end

      class Cancel < Dry::CLI::Command
        desc 'Cancel an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" # Cancels the appointment with Alma Estevez on the specified date and time'
        ]

        def call(date:, professional:)
          Polycon::Models::Appointment.remove(date, professional)
          puts "El turno del profesional #{professional} para la fecha #{date} se cancelo correctamente"
        rescue Polycon::Exceptions::Professional::NotFound,
               Polycon::Exceptions::Appointment::NotExists => e
          warn e.message
        end
      end

      class CancelAll < Dry::CLI::Command
        desc 'Cancel all appointments for a professional'

        argument :professional, required: true, desc: 'Full name of the professional'

        example [
          '"Alma Estevez" # Cancels all appointments for professional Alma Estevez'
        ]

        def call(professional:)
          Polycon::Models::Appointment.remove_all(professional).each do |appo|
            puts "El turno #{File.basename(appo, '.paf')} fue cancelado"
          end
        rescue Polycon::Exceptions::Professional::NotFound,
               Polycon::Exceptions::Appointment::NotExists => e
          warn e.message
        end
      end

      class List < Dry::CLI::Command
        desc 'List appointments for a professional, optionally filtered by a date'

        argument :professional, required: true, desc: 'Full name of the professional'
        option :date, required: false, desc: 'Date to filter appointments by (should be the day)'

        example [
          '"Alma Estevez" # Lists all appointments for Alma Estevez',
          '"Alma Estevez" --date="2021-09-16" # Lists appointments for Alma Estevez on the specified date'
        ]

        def call(professional:)
          Polycon::Models::Appointment.list(professional).each { |appo| puts "- #{File.basename(appo, '.paf')}" }
        rescue Polycon::Exceptions::Professional::NotFound,
               Polycon::Exceptions::Appointment::NotExists => e
          warn e.message
        end
      end

      class Reschedule < Dry::CLI::Command
        desc 'Reschedule an appointment'

        argument :old_date, required: true, desc: 'Current date of the appointment'
        argument :new_date, required: true, desc: 'New date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" "2021-09-16 14:00" --professional="Alma Estevez" # Reschedules appointment on the first date for professional Alma Estevez to be now on the second date provided'
        ]

        def call(old_date:, new_date:, professional:)
          Polycon::Models::Appointment.reschedule(old_date, new_date, professional)
          puts "El turno #{old_date} fue actualizado a #{new_date}"
        rescue Polycon::Exceptions::Professional::NotFound,
               Polycon::Exceptions::Appointment::NotExists,
               Polycon::Exceptions::Appointment::AlreadyExists => e
          warn e.message
        end
      end

      class Edit < Dry::CLI::Command
        desc 'Edit information for an appointments'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'
        option :name, required: false, desc: "Patient's name"
        option :surname, required: false, desc: "Patient's surname"
        option :phone, required: false, desc: "Patient's phone number"
        option :notes, required: false, desc: 'Additional notes for appointment'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" --name="New name" # Only changes the patient\'s name for the specified appointment. The rest of the information remains unchanged.',
          '"2021-09-16 13:00" --professional="Alma Estevez" --name="New name" --surname="New surname" # Changes the patient\'s name and surname for the specified appointment. The rest of the information remains unchanged.',
          '"2021-09-16 13:00" --professional="Alma Estevez" --notes="Some notes for the appointment" # Only changes the notes for the specified appointment. The rest of the information remains unchanged.'
        ]

        def call(date:, professional:, **options)
          Polycon::Models::Appointment.edit(date, professional, options)
          puts 'El turno fue actualizado correctamente'
        rescue Polycon::Exceptions::Professional::NotFound,
               Polycon::Exceptions::Appointment::NotExists => e
          warn e.message
        end
      end

      class Export < Dry::CLI::Command
        desc 'Exports all the appointments of the professionals in a table which is saved in an html file.'

        argument :date, required: true, desc: 'Full date for the appointments'
        option :professional, required: false, default: '', desc: 'Full name of the professional'
        option :fullweek, required: false, default: false, desc: 'If you want to export a complete week'
        option :path, required: false, default: '', desc: 'path in your computer where you want to save the output table'

        example [
          '"2021-09-16" --professional="Alma Estevez" --fullweek="true" #',
          '"2021-09-16" --professional="Alma Estevez" # Week default will be false',
          '"2021-09-16" # will retrieve appointments for all professionales in the specified date',
          '"2021-09-16" --fullweek="true" # will retrieve appointments for all professionales in the week of the specified date starting by sunday',
          '"2021-09-16" --path="/home/user/table.html" # the output table will be save in the path /home/user/table.html'
        ]

        def call(date:, professional:, fullweek:, path:, **options)
          professionals = Polycon::Models::Professional.list_or_filter_by_name(professional)
          result = Polycon::Models::Appointment.list_by_date_and_professional(date, fullweek, professionals)
          range_time = (8..20).flat_map do |hour|
            (0..3).map do |min|
              "#{hour}:#{min*15 == 0 ? '00' : min*15}"
            end
          end

          erb_file_path = File.join(File.dirname(__FILE__), '../templates/calendar.html.erb')
          template = ERB.new(File.read(erb_file_path))
          output_path = File.join(File.dirname(__FILE__), '../templates/text.html')

          File.write(output_path, template.result_with_hash({
            days: result[:days],
            appointments: result[:appointments],
            range_time: range_time
          }))
        rescue Polycon::Exceptions::Professional::NotFound,
               Polycon::Exceptions::Appointment::NotExists => e
          warn e.message
        rescue Date::Error
          puts 'EL formato de la fecha es invalido'
        end
      end
    end
  end
end
