require 'sqlite3'
require 'colorize'
require_relative 'database'
require 'yaml'

module Glint
  class CheatSheet
    def initialize
      @db = Database.new
      @db.create_table
      seed
    end

    def seed
      types = Dir.entries("seed").select do |entry|
        entry.include?('.yml') &&  !entry.start_with?(".")
      end.sort

      types.each do |type|
        default_type = File.basename(type, File.extname(type))
        file_path = "seed/#{type}"
        next unless File.exist?(file_path)

        cheat_sheet = YAML.load_file(file_path)
        cheat_sheet.each do |cheat|
          name = cheat['name']
          description = cheat['description']
          code = cheat['code']

          type_name = cheat['type'] ? cheat['type'] : default_type

          add(type_name, name, code, description) unless exists?(type_name, name)
        end
      end
    end

    def exists?(type, name)
      @db.exists?(type, name)
    end

    def add(type, name, code, description)
      @db.add_cheat(type, name, code, description)
    end

    def update(id, type, name, code, description)
      @db.update_cheat(id, type, name, code, description)
    end

    def delete(name)
      @db.delete_cheat(name)
    end

    def list(type = nil, options = {})
      @db.list_cheats(type, options)
    end

    def search(term, type = nil, options = {})
      @db.search_cheats(term, type, options)
    end
  end
end
