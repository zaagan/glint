require 'sqlite3'
require 'colorize'
require 'terminal-table'
require_relative 'display_handler'
require_relative 'file_handler'

module Glint
  class Database
    include Glint::DisplayHandler
    include ::Glint::FileHandler

    TABLE_NAME = 'cheats'.freeze

    CMD_SELECT_COLUMNS_FROM = 'SELECT type, name, code, description FROM '.freeze

    def initialize
      two_steps_back = move_back(move_back(current_dir_path))
      @db_path = File.join(two_steps_back, 'db')
      @db = SQLite3::Database.new("#{@db_path}/glint.db")
    end

    def drop_table
      @db.execute("DROP TABLE IF EXISTS #{TABLE_NAME};")
    end

    def create_table
      @db.execute <<-SQL
        CREATE TABLE IF NOT EXISTS #{TABLE_NAME} (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          description TEXT,
          code TEXT NOT NULL,
          type TEXT NOT NULL
        );
      SQL
    end

    # CHECK IF THERE IS AN ENTRY WITH A NAME AND TYPE
    def exists?(type, name)
      result = @db.execute('SELECT COUNT(*) FROM cheats WHERE name = ? AND type = ?', [name, type])
      count = result[0][0]
      count.positive?
    end

    # ADD NEW CHEAT
    def add_cheat(type, name, code, description = '')
      @db.execute("INSERT INTO #{TABLE_NAME} (type, name, code, description) VALUES (?, ?, ?, ?)", [type, name, code, description])
    end

    # UPDATE BY ID
    def update_cheat(id, type, name, code, description = '')
      sql = "UPDATE #{TABLE_NAME} SET name = ?, code = ?,  description = ?, type = ? WHERE id = ?"
      @db.execute(sql, name, code, description, type, id)
    end

    # DELETE BY NAME
    def delete_cheat(name)
      @db.execute("DELETE FROM #{TABLE_NAME} WHERE name = ?", [name])
    end

    # LIST ALL CHEATS
    def list_cheats(type = nil, options = {})
      sql = "#{CMD_SELECT_COLUMNS_FROM} #{TABLE_NAME}"

      if type.nil?
        rows = @db.execute(sql)
      else
        sql += ' WHERE type = ?'
        rows = @db.execute(sql, type)
      end

      print_rows(rows, type, nil, options)
    end

    def search_cheats(term, type = nil, options = {})

      if type.nil?
        sql = "#{CMD_SELECT_COLUMNS_FROM} #{TABLE_NAME} WHERE name LIKE ? OR description LIKE ? OR code LIKE ? OR type LIKE ?"
        rows = @db.execute(sql, "%#{term}%", "%#{term}%", "%#{term}%", "%#{term}%")
      else
        sql = "#{CMD_SELECT_COLUMNS_FROM} #{TABLE_NAME} WHERE (name LIKE ? OR description LIKE ? OR code LIKE ?) AND type = ?"
        rows = @db.execute(sql, "%#{term}%", "%#{term}%", "%#{term}%", type)
      end

      print_rows(rows, type, term, options)
    end
  end
end
