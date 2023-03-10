require 'sqlite3'
require 'colorize'
require_relative 'database'
require_relative 'file_handler'
require 'yaml'

module Glint
  class CheatSheet
    include ::Glint::FileHandler

    attr_reader :all_types, :seeds_path

    def initialize
      two_steps_back = move_back(move_back(current_dir_path))
      @seeds_path = File.join(two_steps_back, 'seed')

      @db = Database.new
      @db.create_table
      @all_types = []
      seed
    end

    def reset
      @db.drop_table
      @db.create_table
      seed
    end

    def seed
      types = load_files
      types.each do |type|

        default_type = File.basename(type, File.extname(type))
        file_path = "#{seeds_path}/#{type}"
        next unless File.exist?(file_path)

        cheat_sheet = YAML.load_file(file_path)
        cheat_sheet.each do |cheat|
          name = cheat['name']
          description = cheat['description']
          code = cheat['code']

          type_name = cheat['type'] || default_type
          @all_types << type_name

          add(type_name, name, code, description) unless exists?(type_name, name)
        rescue StandardError => e
          puts e.to_s
          puts "Failed to insert glint. #{type} : #{cheat}"
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

    private

    def load_files
      Dir.entries(seeds_path).select do |entry|
        entry.include?('.yml') && !entry.start_with?('.')
      end.sort
    end
  end
end
