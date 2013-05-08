require 'json'

module Shellissimo

  class InputParser
    COMMAND_PATTERN = /(\w+)(?:\s*(.*))/

    #
    # @param commands [#find_by_name_or_alias] a list of commands
    #
    def initialize(commands)
      @commands = commands
    end

    #
    # @param line [String] a line of input from shell
    # @return [Command] a command with pre-populated params
    #
    def parse_command(line)
      command_name, command_params = line.match(COMMAND_PATTERN)[1..2]
      command = @commands.find_by_name_or_alias(command_name)
      command.prepend_params(parse_params(command_params))
    end

    private

    def parse_params(params_string)
      params_json = normalize_json(params_string)
      symbolize_hash_keys(JSON.parse(params_json))
    rescue JSON::ParserError => e
      raise ArgumentError, "Can not parse command params: #{e.message}"
    end

    def normalize_json(json_string)
      json_string.gsub(/\A(.*)\Z/, "{\\1}").gsub(/([{,]\s*)(\w+)(\s*:\s*["\d])/, '\1"\2"\3')
    end

    def symbolize_hash_keys(hash)
      hash.inject({}) { |h, (k, v)| h[k.to_sym] = v; h }
    end
  end

end

