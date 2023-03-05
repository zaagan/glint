require 'thor'
require_relative 'cheat_sheet'

module Glint
  class CLI < Thor
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
    def list(type = nil)
      sheet.list(type)
    end

    desc 'search SEARCH_TERM [TYPE]', 'List all cheats'
    def search(term, type = nil)
      sheet.search(term, type)
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
