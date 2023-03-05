require 'thor'
require_relative 'cheat_sheet'

module Glint
  class CLI < Thor
    desc 'add NAME DESCRIPTION CODE', 'Add a cheat'
    def add(name, description, code)
      sheet.add(name, description, code)
    end

    desc 'delete NAME', 'Delete a cheat'
    def delete(name)
      sheet.delete(name)
    end

    desc 'list', 'List all cheats'
    def list
      sheet.list
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
