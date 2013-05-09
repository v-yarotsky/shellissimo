require 'shellissimo/command_param'
require 'shellissimo/command_param_validator'

module Shellissimo
  module DSL

    class CommandParamBuilder
      attr_reader :name, :description

      def initialize(name)
        @name = name
        @stock_validator = :noop
        @validator = CommandParamValidator.noop
      end

      def description(desc)
        @description = desc
      end

      def validate(description = "", &block)
        @validator = CommandParamValidator.new(description, &block)
      end

      def mandatory!
        @validator = CommandParamValidator.mandatory & @validator
      end

      def result
        CommandParam.new(@name, @validator, @description)
      end
    end

  end
end
