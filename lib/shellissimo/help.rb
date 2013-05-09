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
      @commands.partition { |c| !%w(help quit).include? c.name.name }.each do |cs|
        cs.sort_by(&:name).each(&method(:render_command))
        line
      end
    end

    def line(str = "")
      @rendered += "#{str}\n"
    end

    def render_command(cmd)
      render_name_and_description(cmd.name, cmd.description, "%-40s")
      cmd.param_definitions.each { |p| render_param(p) }
    end

    def render_param(param)
      render_name_and_description(param.name, param.description, "  %-30s")
    end

    def render_name_and_description(name, description, name_format)
      formatted_name = name_format % [name]
      formatted_description = ""
      formatted_description = " - %s" % [description] unless description.empty?
      line formatted_name + formatted_description
    end
  end

end
