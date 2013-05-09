module Shellissimo

  class Help
    def initialize(commands)
      @commands = commands
      @rendered = ""
      render
    end

    def rendered
      @rendered.dup.chomp
    end

    private

    def render
      line "Available commands:"
      line
      @commands.partition { |c| !builtin_commands.include? c }.each do |cs|
        cs.sort_by(&:name).each(&method(:render_command))
        line
      end
    end

    def line(str = "")
      @rendered += "#{str}\n"
    end

    def builtin_commands
      %w(help quit).map { |n| @commands[n] }
    end

    def render_command(cmd)
      render_name_and_description(cmd.name, "%-40s", cmd.description)
      cmd.param_definitions.each { |p| render_param(p) }
    end

    def render_param(param)
      render_name_and_description(param.name, "  %-30s", param.description, param.validator.description)
    end

    def render_name_and_description(name, name_format, *details)
      formatted_name = name_format % [name]
      details.map! { |d| " - %s" % [d] unless d.empty? }
      line String(formatted_name) + details.join
    end
  end

end
