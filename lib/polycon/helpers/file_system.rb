module Polycon
  module Helpers
    module FileSystem
      POLYCON_FOLDER = '.polycon'
      def self.format_path(folder, file = '')
        File.join(Dir.home, POLYCON_FOLDER, folder, file)
      end

      def self.create_folder(folder)
        FileUtils.mkdir_p(format_path(folder))
      end

      def self.create_file(folder, file)
        FileUtils.touch(format_path(folder, file))
      end

      def self.file_exist?(folder, file = '')
        Dir.exist?(format_path(folder, file))
      end

      def self.list_files(folder)
        Dir.entries(format_path(folder)).select { |f| File.file?(format_path(folder, f)) }
      end

      def self.list_folders
        Dir.entries(format_path('')).reject { |f| File.file?(format_path(f)) || f == '.' || f == '..' }
      end

      def self.remove_folder(folder)
        FileUtils.rm_rf(format_path(folder))
      end

      def self.rename(old_name, new_name)
        FileUtils.move(format_path(old_name), format_path(new_name))
      end
    end
  end
end
