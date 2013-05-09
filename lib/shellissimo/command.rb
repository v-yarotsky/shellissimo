require 'shellissimo/command_name'

module Shellissimo

  class Command
    attr_reader :name, :aliases, :description, :param_definitions, :block

    def initialize(name, description = "", aliases = [],  param_definitions = [], &block)
      @name, @description = CommandName.new(name, aliases), String(description)
      @param_definitions = Array(param_definitions)
      self.block = block
    end

    def block=(b)
      @block = b or raise ArgumentError, "command block is required"
    end

    def prepend_params(params)
      params = filter_params(params)
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

    private

    def filter_params(params)
      acceptable_param_names = @param_definitions.map(&:name).map(&:to_s)
      filtered = Hash[params.select { |k, v| acceptable_param_names.include? k.to_s }]

      filtered = {}
      @param_definitions.each do |p|
        raise ArgumentError, "param '#{p.name}' is not valid!" unless p.valid?(params[p.name])
        filtered[p.name] = params[p.name]
      end
      filtered
    end
  end

end

