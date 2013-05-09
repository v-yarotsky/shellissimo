require 'shellissimo/command_param_validator'

module Shellissimo

  class CommandParam
    attr_reader :description, :validator

    def initialize(name, validator = nil, description = "")
      @name, @description = String(name), String(description)
      raise ArgumentError, "command param name can't be blank" if @name.empty?
      @validator = validator || CommandParamValidator.noop
    end

    def name
      @name.to_sym
    end

    def valid?(value)
      !!@validator[value]
    end
  end

end
