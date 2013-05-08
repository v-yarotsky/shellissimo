require 'shellissimo/command_name'

module Shellissimo

  class Command
    attr_reader :name, :aliases, :description, :params, :block

    def initialize(name, description = "", aliases = [],  params = [], &block)
      @name, @description, @params = CommandName.new(name, aliases), String(description), params
      @block = block or raise ArgumentError, "command block is required"
    end

    def prepend_params(params)
      dup.tap { |c| c.instance_variable_set(:@block, proc { |*args| block[params, *args] }) }
    end

    def call(*args)
      block.call(*args)
    end
    alias_method :[], :call
  end

end

