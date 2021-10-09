module Polycon
  module Helpers
    module FileSystem
      POLYCON_FOLDER = '.polycon'
      def self.format_filename(name)
        if name.empty?
          ''
        else
          "#{name}.paf"
        end
      end

      def self.format_path(folder, file = '')
        File.join(Dir.home, POLYCON_FOLDER, folder.downcase, format_filename(file.downcase))
      end

      def self.create_folder(folder)
        FileUtils.mkdir_p(format_path(folder))
      end

      def self.folder_exist?(folder)
        Dir.exist?(format_path(folder))
      end

      def self.list_folders
        Dir.entries(format_path('')).reject { |f| File.file?(format_path(f)) || f == '.' || f == '..' }
      end

      def self.remove_file(folder, file = '')
        FileUtils.rm_rf(format_path(folder, file))
      end

      def self.rename(old_name, new_name)
        FileUtils.move(format_path(old_name), format_path(new_name))
      end

      def self.create_file(folder, file)
        FileUtils.touch(format_path(folder, file))
      end

      def self.file_exist?(folder, file)
        File.file?(format_path(folder, file))
      end

      def self.list_files(folder)
        Dir.entries(format_path(folder)).select { |f| File.file?(format_path(folder, f.chomp(".paf"))) }
      end

      def self.insert_content(folder, filename, content)
        file = File.open(format_path(folder, filename), 'w')
        content.each { |line| file << "#{line}\n" }
        file.close
      end

      def self.read_file(folder, file)
        File.read(format_path(folder, file)).split("\n")
      end
    end
  end
end
