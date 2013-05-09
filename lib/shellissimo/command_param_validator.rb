module Shellissimo

  class CommandParamValidator
    attr_reader :description, :block

    class << self
      def noop
        new { |v| true }
      end

      def optional
        new("optional") { |v| v.nil? }
      end

      def mandatory
        new("mandatory") { |v| !v.nil? }
      end
    end

    def initialize(description = "", &block)
      @description = description
      @block = block or
        raise ArgumentError, "command param validator block can't be blank"
    end

    def call(value)
      @block.call(value)
    end
    alias :[] :call

    def &(other)
      CommandParamValidator.new(description) { |value| block[value] && other.block[value] }
    end

    def |(other)
      CommandParamValidator.new(description) { |value| block[value] || other.block[value] }
    end
  end

end


