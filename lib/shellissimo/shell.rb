require 'readline'
require 'shellissimo/error_handling'
require 'shellissimo/dsl'
require 'shellissimo/input_parser'
require 'shellissimo/help'

module Shellissimo

  #
  # Base class for Shells
  # Allows to define commands via DSL
  # @see DSL
  # Arovides 'help' and 'quit' commands out-of-box
  #
  # Supports REPL and one-shot mode
  #
  # Commands are instance-evaled against Shell instance,
  # so all instance variables are available in command blocks.
  #
  # Example:
  #
  #   class MyShell < Shellissimo::Shell
  #     command :hi do |c|
  #       c.description "Says hello to the user"
  #       c.run { |params| @greeter.say_hi(params[:user]) }
  #     end
  #
  #     def initialize
  #       @greeter = Greeter.new
  #     end
  #   end
  #
  # Usage:
  #
  #   -> hi user: "vlyrs"
  #
  class Shell
    include DSL

    command :help do |c|
      c.shortcut :h
      c.description "Show available commands"
      c.run { |*| Help.new(self.class.commands).rendered }
    end

    command :quit do |c|
      c.shortcut :exit
      c.description "Quit #$0"
      c.run { |*| exit 0 }
    end

    def initialize(*)
      @input_parser = InputParser.new(self.class.commands)
    end

    #
    # Runs REPL
    # @note swallows exceptions!
    #
    def run
      while buf = Readline.readline(prompt, true) do
        run_command(buf)
      end
    end

    #
    # Runs a single command
    # @param str [String] command and parameters (like for REPL)
    # @note swallows exceptions!
    #
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

