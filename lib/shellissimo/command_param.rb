module Shellissimo

  class CommandParam
    attr_reader :description, :validator

    NOOP_VALIDATOR = proc { true }
    STOCK_VALIDATORS = {
      :noop => NOOP_VALIDATOR,
      :mandatory => proc { |v| !v.nil? }
    }.freeze

    def initialize(name, stock_validator = :noop, description = "", &validator)
      @name, @description = String(name), String(description)
      raise ArgumentError, "command param name can't be blank" if @name.empty?

      stock_validator = STOCK_VALIDATORS[stock_validator || :noop]
      @validator = if validator
        proc { |v| stock_validator[v] && validator[v] }
      else
        stock_validator
      end
    end

    def name
      @name.to_sym
    end

    def valid?(value)
      !!@validator[value]
    end
  end

end
