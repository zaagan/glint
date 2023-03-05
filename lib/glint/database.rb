require 'sqlite3'
require 'colorize'
require 'terminal-table'

module Glint
  class Database
    TABLE_NAME = 'cheats'.freeze

    def initialize
      @db = SQLite3::Database.new('db/glint.db')
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
    def exists?(type, name )
      result = @db.execute("SELECT COUNT(*) FROM cheats WHERE name = ? AND type = ?", [name, type])
      count = result[0][0]
      count > 0
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
    def list_cheats(type = nil)
      sql = "SELECT type, name, code, description FROM #{TABLE_NAME}"

      if type.nil?
        rows = @db.execute(sql)
      else
        sql += " WHERE type = ?"
        rows = @db.execute(sql, type)
      end

      print_rows(rows)
    end

    def search_cheats(term, type = nil)
      if type.nil?
        sql = "SELECT type, name, code, description FROM #{TABLE_NAME} WHERE name LIKE ? OR description LIKE ? OR code LIKE ?"
        rows = @db.execute(sql, "%#{term}%", "%#{term}%", "%#{term}%")
      else
        sql = "SELECT type, name, code, description FROM #{TABLE_NAME} WHERE (name LIKE ? OR description LIKE ? OR code LIKE ?) AND type = ?"
        rows = @db.execute(sql, "%#{term}%", "%#{term}%", "%#{term}%", type)
      end

      print_rows(rows)
    end

    private

    def print_rows(rows)
      table_rows = rows.map do |row|
        type = row[0]
        name = row[1].colorize(:light_blue).bold
        code = row[2].colorize(:light_green)
        description = row[3]

        [type, name, code, description]
      end

      table = Terminal::Table.new(
        headings: ['Type', 'Name', 'Code', 'Description'],
        rows: table_rows,
        style: {
          border_x: '',
          border_i: '',
          border_y: '',
          padding_left: 0,
          padding_right: 2
        }
      )
      table.align_column(0, :left)
      table.align_column(1, :left)
      table.align_column(2, :left)
      table.align_column(3, :left)

      puts table
    end
  end
end
