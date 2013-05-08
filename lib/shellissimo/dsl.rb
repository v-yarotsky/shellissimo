require 'shellissimo/command'

module Shellissimo

  module DSL
    def self.included(base)
      base.extend ClassMethods
    end

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

    module ClassMethods
      def command(name)
        builder = CommandBuilder.new(name)
        yield builder
        commands << builder.result
      end

      def commands
        @commands ||= begin
          c = []
          def c.find_by_name_or_alias(name_or_alias)
            detect { |c| c.name == name_or_alias }
          end
          c
        end
      end
    end
  end

end
