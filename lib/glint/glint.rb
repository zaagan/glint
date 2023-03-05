require 'thor'
require_relative 'cheat_sheet'

module Glint
  class CLI < Thor
    desc 'reset', 'Reset Glint to initial state'
    def reset
      puts "This will delete all cheat sheets and reset the database. Do you want to continue? (y/n)"
      answer = STDIN.gets.chomp.downcase
      if answer == 'y' || answer == 'yes'
        sheet.reset
      else
        puts "Aborting reset."
      end
    end

    desc 'add TYPE, NAME CODE [DESCRIPTION] ', 'Add a cheat'
    def add(type, name, code, description = '')
      sheet.add(type, name, code, description)
    end

    desc 'delete NAME', 'Delete a cheat'
    def delete(name)
      sheet.delete(name)
    end

    desc 'update ID TYPE NAME CODE [DESCRIPTION]', 'Update a cheat'
    def update(id, type, name, code, description = '')
      sheet.update(id, type, name, code, description)
    end

    desc 'list [TYPE]', 'List all cheats'
    method_option :description, type: :boolean, aliases: "-d", desc: "Display descriptions"
    def list(type = nil)
      sheet.list(type, options)
    end

    desc 'search SEARCH_TERM [TYPE]', 'List all cheats'
    method_option :description, type: :boolean, aliases: "-d", desc: "Display descriptions"
    def search(term, type = nil)
      sheet.search(term, type, options)
    end

    private

    def sheet
      @sheet ||= CheatSheet.new
    end
  end

  def self.start(args)
    CLI.start(args)
  end
end
