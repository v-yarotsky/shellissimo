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
        commands << builder.result
      end

    end

    module ClassMethods
      #
      # @return [CommandsCollection] a list of defined commands
      #
      def commands
        @@commands ||= CommandsCollection.new
      end
    end
  end

end
