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
          name TEXT PRIMARY KEY,
          description TEXT,
          code TEXT
        );
      SQL
    end

    def add_cheat(name, description, code)
      @db.execute("INSERT INTO #{TABLE_NAME} (name, description, code) VALUES (?, ?, ?)", [name, description, code])
    end

    def delete_cheat(name)
      @db.execute("DELETE FROM #{TABLE_NAME} WHERE name = ?", [name])
    end

    def list_cheats
      rows = @db.execute("SELECT name, description, code FROM #{TABLE_NAME}")
      table_rows = rows.map do |row|
        name = row[0].colorize(:light_blue).bold
        description = row[1]
        code = row[2].colorize(:light_green)
        [name, description, code]
      end
      table = Terminal::Table.new(
        headings: ['Name', 'Description', 'Code'],
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
      puts table

      # Version 3
      # rows = @db.execute("SELECT name, description, code FROM #{TABLE_NAME}")
      # table_rows = rows.map do |row|
      #   name = row[0].colorize(:light_blue).bold
      #   description = row[1].colorize(:light_green)
      #   code = row[2]
      #   [name, description, code]
      # end

      # table = Terminal::Table.new(
      #   headings: ['Name', 'Description', 'Code'],
      #   rows: table_rows,
      #   style: {
      #     border_x: '',
      #     border_i: '',
      #     border_y: '',
      #     padding_left: 0,
      #     padding_right: 0,
      #     all_separators: true,
      #     width: 80 #Terminal::Table::WIDTHS.copy_push(20, 30, 50)
      #   }
      # )
      # puts table

      # Version 2
      # rows = @db.execute("SELECT name, description, code FROM #{TABLE_NAME}")
      # table = Terminal::Table.new(
      #   headings: ['Name', 'Description', 'Code'],
      #   rows: rows,
      #   style: {
      #     width: 80,
      #     border_x: '',
      #     border_i: '',
      #     border_y: ''
      #   }
      # )
      # puts table

      # Version 1
      #   rows = @db.execute("SELECT name, description, code FROM #{TABLE_NAME}")
      #   puts rows.map { |row| format_cheat(row) }
    end

    private

    def format_cheat(row)
      name, description, code = row
      [name.colorize(:green), description.colorize(:blue), code].join("\n")
    end
  end
end
