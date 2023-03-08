require 'thor'
require_relative 'cheat_sheet'
require 'terminal-table'

module Glint
  class CLI < Thor
    include Glint::DisplayHandler

    desc 'menu', 'Displays a menu of available types and allows the user to choose one'
    def menu
      types = sheet.all_types.uniq
      print_types(types)
    end

    desc 'reset', 'Reset Glint to initial state'
    def reset
      puts 'This will delete all cheat sheets and reset the database. Do you want to continue? (y/n)'
      answer = $stdin.gets.chomp.downcase
      if %w['y', 'yes'].include?(answer)
        sheet.reset
      else
        puts 'Aborting reset.'
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
    method_option :description, type: :boolean, aliases: '-d', desc: 'Display descriptions'
    def list(type = nil)
      sheet.list(type, options)
    end

    desc 'search SEARCH_TERM [TYPE]', 'List all cheats'
    method_option :description, type: :boolean, aliases: '-d', desc: 'Display descriptions'
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
