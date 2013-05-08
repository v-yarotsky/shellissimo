require 'shellissimo/command'

module Shellissimo
  module DSL

    class CommandBuilder
      def initialize(name)
        @name = name
      end

      def description(desc)
        @description = desc
      end

      def shortcut(*aliases)
        @aliases = Array(aliases)
      end
      alias :shortcuts :shortcut

      def run(&block)
        @block = block
      end

      def result
        Command.new(String(@name), @description, @aliases, &@block)
      end
    end

  end
end
