module Polycon
  module Models
    class Profesional
      attr_accessor :name

      def initialize(name)
        self.name = name
      end

      def self.create
        Polycon::Helpers::FileSystem.create_folder(name)
      end

      def list; end

      def remove; end

      def modify; end
    end
  end
end
