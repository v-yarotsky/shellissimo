require 'shellissimo/command_param'
require 'shellissimo/command_param_validator'

module Shellissimo
  module DSL

    class CommandParamBuilder
      attr_reader :name, :description

      def initialize(name)
        @name = name
        @validator = CommandParamValidator.noop
        @kind = :optional
      end

      def description(desc)
        @description = desc
      end

      def validate(description = "", &block)
        @validator = @validator & CommandParamValidator.new(description, &block)
      end

      #
      # @private
      #
      def mandatory!
        @kind = :mandatory
      end

      #
      # @private
      #
      def optional!
        @kind = :optional
      end

      def result
        CommandParam.new(@name, validator, @description)
      end

      private

      def validator
        case @kind
        when :optional
          CommandParamValidator.optional | @validator
        when :mandatory
          CommandParamValidator.mandatory & @validator
        end
      end
    end

  end
end
