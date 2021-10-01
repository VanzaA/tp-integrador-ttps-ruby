module Polycon
  module Helpers
    module FileSystem
      def self.format_path(folder, file = '')
        File.join(Dir.home, folder, file)
      end

      def self.create_folder(folder)
        FileUtils.mkdir_p(format_path(folder))
      end

      def self.create_file(folder, file)
        FileUtils.touch(format_path(folder, file))
      end

      def folder_exist?(_folder)
        Dir.exist?(format_path(name))
      end
    end
  end
end
