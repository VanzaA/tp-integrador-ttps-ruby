module Polycon
  module Models
    class Professional
      attr_accessor :name

      def initialize(name)
        self.name = name
      end

      def self.create(name)
        if Polycon::Helpers::FileSystem.folder_exist?(name)
          raise Polycon::Exceptions::Professional::ProfessionalExist.new("El profesional #{name} ya existe")
        end
        Polycon::Helpers::FileSystem.create_folder(name)
        new(name)
      end

      def list; end

      def remove; end

      def modify; end

      def self.find(name)
        return new(name) if Polycon::Helpers::FileSystem.folder_exist?(name)
        nil
      end
    end
  end
end
