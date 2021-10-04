module Polycon
  module Commands
    module Professionals
      class Create < Dry::CLI::Command
        desc 'Create a professional'

        argument :name, required: true, desc: 'Full name of the professional'

        example [
          '"Alma Estevez"      # Creates a new professional named "Alma Estevez"',
          '"Ernesto Fernandez" # Creates a new professional named "Ernesto Fernandez"'
        ]

        def call(name:, **)
          begin
            Polycon::Models::Professional.create(name)
            puts "El profesional #{name} se creo correctamente"
          rescue Polycon::Exceptions::Professional::ProfessionalExist => e
            puts e.message
          end
        end
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a professional (only if they have no appointments)'

        argument :name, required: true, desc: 'Name of the professional'

        example [
          '"Alma Estevez"      # Deletes a new professional named "Alma Estevez" if they have no appointments',
          '"Ernesto Fernandez" # Deletes a new professional named "Ernesto Fernandez" if they have no appointments'
        ]

        def call(name: nil)
        #   professional = professional.find(name)
        #   if profesional.nil?
        #     warn "El profesional #{name} no existe"
        #   else
        #     profesional.delete
        #     puts "El profesional #{name} se elimino correctamente"
        #   end
        end
      end

      class List < Dry::CLI::Command
        desc 'List professionals'

        example [
          "          # Lists every professional's name"
        ]

        def call(*)
          # professionals_list = Professional.list
          # if professionals_list.length == 0
          #   professional_list.map { |professional| puts "#{professional}"}
          # else
          #   puts "No se encontro ningun profesional"
        end
      end

      class Rename < Dry::CLI::Command
        desc 'Rename a professional'

        argument :old_name, required: true, desc: 'Current name of the professional'
        argument :new_name, required: true, desc: 'New name for the professional'

        example [
          '"Alna Esevez" "Alma Estevez" # Renames the professional "Alna Esevez" to "Alma Estevez"'
        ]

        def call(old_name:, new_name:, **)
          # professional = Professional.find(name)
          # if profesional.nil?
          #   warn "El profesional #{name} no existe"
          # else
          #   professional.rename(new_name)
          #   puts "El professional se actualizo correctamente"
          # end
        end
      end
    end
  end
end
