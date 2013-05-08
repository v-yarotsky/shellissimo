require 'shellissimo/command_name'

module Shellissimo

  class Command
    attr_reader :name, :aliases, :description, :params, :block

    def initialize(name, description = "", aliases = [],  params = [], &block)
      @name, @description, @params = CommandName.new(name, aliases), String(description), params
      self.block = block
    end

    def block=(b)
      @block = b or raise ArgumentError, "command block is required"
    end

    def prepend_params(params)
      old_block = block # let's fool ruby
      dup.tap { |c| c.block = proc { instance_exec(params, &old_block) } }
    end

    def call(*args)
      block.call(*args)
    end
    alias_method :[], :call

    def to_proc
      block
    end
  end

end

