module Glint
  module FileHandler
    def current_dir_path
      File.dirname(__FILE__)
    end

    def move_back(path)
      File.expand_path('../', path)
    end
  end
end
