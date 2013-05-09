require 'shellissimo/command'
require 'shellissimo/dsl/command_param_builder'

module Shellissimo
  module DSL

    class CommandBuilder
      def initialize(name)
        @name = name
        @param_definitions = []
      end

      def description(desc)
        @description = desc
      end

      def shortcut(*aliases)
        @aliases = Array(aliases)
      end
      alias :shortcuts :shortcut

      #
      # A block to run upon command execution
      #
      def run(&block)
        @block = block
      end

      def param(name)
        builder = CommandParamBuilder.new(name)
        yield builder if block_given?
        @param_definitions << builder.result
      end

      def mandatory_param(name)
        param(name) { |p| p.mandatory!; yield p if block_given? }
      end

      def result
        Command.new(String(@name), @description, @aliases, @param_definitions, &@block)
      end
    end

  end
end
