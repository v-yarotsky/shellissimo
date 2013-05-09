require 'shellissimo/command_param'

module Shellissimo
  module DSL

    class CommandParamBuilder
      attr_reader :name, :description, :stock_validator

      def initialize(name)
        @name = name
        @stock_validator = :noop
      end

      def description(desc)
        @description = desc
      end

      def validate(&block)
        @block = block
      end

      def mandatory!
        @stock_validator = :mandatory
      end

      def result
        CommandParam.new(@name, @stock_validator, @description, &@block)
      end
    end

  end
end
