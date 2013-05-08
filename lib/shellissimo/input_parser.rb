require 'json'

module Shellissimo

  class CommandNotFoundError < StandardError; end

  class InputParser
    COMMAND_PATTERN = /(\w+)(?:\s*(.*))/

    def initialize(commands)
      @commands = commands
    end

    def parse_command(line)
      command_name, command_params = line.match(COMMAND_PATTERN)[1..2]
      command = @commands.find_by_name_or_alias(command_name) or
        raise CommandNotFoundError, "Command #{command_name} not found"
      command.prepend_params(parse_params(command_params))
    end

    private

    def parse_params(params_string)
      params_json = params_string.gsub(/\A(.*)\Z/, "{\\1}").gsub(/([{,]\s*)(\w+)(\s*:\s*["\d])/, '\1"\2"\3')
      JSON.parse(params_json).inject({}) { |h, (k, v)| h[k.to_sym] = v; h }
    rescue JSON::ParserError => e
      raise ArgumentError, "Can not parse command params: #{e.message}"
    end
  end

end

