require 'sqlite3'
require 'colorize'
require_relative 'database'

module Glint
  class CheatSheet
    def initialize
      @db = Database.new
      @db.create_table
    end

    def add(name, description, code)
      @db.add_cheat(name, description, code)
    end

    def delete(name)
      @db.delete_cheat(name)
    end

    def list
      @db.list_cheats
    end
  end
end
