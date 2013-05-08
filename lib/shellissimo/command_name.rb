module Shellissimo

  class CommandName
    include Comparable

    attr_reader :name, :aliases

    def initialize(name, aliases = [])
      @name, @aliases = String(name), Array(aliases).map(&:to_s)
      raise ArgumentError, "command name can't be blank" if @name.empty?
    end

    def hash
      @name.hash ^ @aliases.hash
    end

    def ==(other)
      case other
      when CommandName
        return true if other.equal? self
        return true if name == other.name && aliases == other.aliases
      when String, Symbol
        return true if other.to_s == @name
        return true if @aliases.include?(other.to_s)
      else
        false
      end
    end

    def <=>(other)
      self == other or name <=> other.name
    end

    def to_s
      result = "\e[1m#{name}\e[0m"
      result += " (aliases: #{aliases.join(", ")})" unless aliases.empty?
      result
    end

    def inspect
      "<CommandName:#{self.object_id} name: #{@name.inspect}, aliases: #{@aliases.inspect}"
    end
  end

end

