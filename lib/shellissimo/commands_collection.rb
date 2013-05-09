require 'forwardable'

module Shellissimo

  class CommandsCollection
    include Enumerable
    extend Forwardable

    def_delegators :@commands, :size

    def initialize
      @commands = []
    end

    def find_by_name_or_alias(name_or_alias)
      @commands.detect { |c| c.name == name_or_alias } or
        raise CommandNotFoundError, "Command #{name_or_alias} not found"
    end
    alias :[] :find_by_name_or_alias

    def each(&block)
      @commands.each(&block)
    end

    def <<(command)
      @commands << command
      self
    end

    def push(*commands)
      @commands.push(*commands)
      self
    end
  end

end
