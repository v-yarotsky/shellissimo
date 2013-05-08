require 'readline'
require 'shellissimo/error_handling'
require 'shellissimo/command'
require 'shellissimo/dsl'
require 'shellissimo/input_parser'

module Shellissimo

  class Shell
    include DSL

    command :help do |c|
      c.shortcut :h
      c.description "Show available commands"
      c.run do |*|
        result = "Available commands:\n\n"
        print_command = proc { |cmd| result += "%-40s - %s\n" % [cmd.name, cmd.description] }
        commands.partition { |c| !%w(help quit).include? c.name.name }.each do |some_commands|
          some_commands.sort_by(&:name).each(&print_command)
          result += "\n"
        end
        result.chomp
      end
    end

    command :quit do |c|
      c.description "Quit #$0"
      c.run { |*| exit 0 }
    end

    def initialize(*)
      @input_parser = InputParser.new(self.class.commands)
    end

    def run
      while buf = Readline.readline(prompt, true) do
        run_command(buf)
      end
    end

    def run_command(str)
      Shellissimo.with_error_handling do
        command = @input_parser.parse_command(str)
        puts format instance_eval(&command.block)
      end
    end

    private

    def prompt
      '-> '
    end

    def format(obj)
      case obj
      when String
        obj
      when Hash
        obj.map { |data| "%-20s: %s" % data }.join("\n")
      when Array
        obj.map(&method(:format)).join("\n")
      else
        obj.inspect
      end
    end
  end

end

