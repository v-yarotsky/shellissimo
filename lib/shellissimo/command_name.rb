module Shellissimo

  class CommandName
    include Comparable

    attr_reader :name, :aliases

    def initialize(name, aliases = [])
      raise ArgumentError, "command name can't be blank" if String(name).empty?
      @name, @aliases = name.to_sym, Array(aliases).map(&:to_sym)
    end

    def hash
      @name.hash ^ @aliases.hash
    end

    def ==(other)
      case other
      when CommandName
        return true if other.equal? self
        return true if name == other.name && aliases == other.aliases
        false
      when String, Symbol
        return true if other.to_sym == @name
        return true if @aliases.include?(other.to_sym)
        false
      else
        false
      end
    end
    alias :eql? :==

    def <=>(other)
      self == other or name <=> other.name
    end

    def to_s
      result = "\e[1m#{name}\e[0m"
      result += " (aliases: #{aliases.join(", ")})" unless aliases.empty?
      result
    end
  end

end

