require 'shellissimo/dsl/command_builder'

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
      # @return [Array] a list of defined commands
      #
      def commands
        @@commands ||= begin
          c = Array.new
          def c.find_by_name_or_alias(name_or_alias)
            detect { |c| c.name == name_or_alias } or
              raise CommandNotFoundError, "Command #{name_or_alias} not found"
          end
          c
        end
      end
    end
  end

end
