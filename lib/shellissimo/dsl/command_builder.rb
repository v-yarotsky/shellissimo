require 'shellissimo/command'
require 'shellissimo/dsl/command_param_builder'

module Shellissimo
  module DSL

    class CommandBuilder
      def initialize(name, param_builder_class = CommandParamBuilder)
        @name = name
        @param_definitions = []
        @param_builder_class = param_builder_class
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

      #
      # Defines a single command param
      # @see CommandParamBuilder
      # @param name [String] name for command param
      # @yieldparam [CommandParamBuilder]
      # @return [CommandParam]
      #
      def param(name)
        builder = @param_builder_class.new(name)
        yield builder if block_given?
        @param_definitions << builder.result
        builder.result
      end

      #
      # Defines mandatory command param
      # @see #param
      #
      def mandatory_param(name)
        param(name) { |p| p.mandatory!; yield p if block_given? }
      end

      def result
        Command.new(String(@name), @description, @aliases, @param_definitions, &@block)
      end
    end

  end
end
