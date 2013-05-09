require 'shellissimo/dsl/command_builder'
require 'shellissimo/commands_collection'

module Shellissimo
  class CommandNotFoundError < StandardError; end

  #
  # Provides a DSL for defining shellissimo commands
  #
  module DSL
    def self.included(base)
      base.extend ClassMethods
      base.extend Macros
    end

    module Macros
      #
      # @param name [String] Primary name for command
      # @yieldparam [CommandBuilder] command_builder
      #
      def command(name)
        builder = CommandBuilder.new(name)
        yield builder
        add_command(builder.result)
      end
    end

    module ClassMethods
      #
      # @return [CommandsCollection] a list of defined commands
      #
      def commands
        CommandsCollection.new
      end

      def add_command(command)
        new_commands = (commands << command)
        define_singleton_method :commands do
          new_commands
        end
      end
    end
  end

end
