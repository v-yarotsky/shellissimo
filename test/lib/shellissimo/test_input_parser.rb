require 'test_helper'
require 'shellissimo/input_parser'
require 'shellissimo/command'
require 'shellissimo/command_param'

include Shellissimo

class TestInputParser < ShellissimoTestCase
  test "returns command by name" do
    assert_equal parser.parse_command("foo").name, "foo"
  end

  test "supports multiple params" do
    assert_equal [{ :a => 1, :b => 2 }], parser.parse_command('foo "a": 1, "b": 2')[]
  end

  test "supports quoted params" do
    assert_equal [{ :a => "hello, world", :b => nil }], parser.parse_command('foo "a": "hello, world"')[]
  end

  test "supports unquoted keys" do
    assert_equal [{ :a => "hello, world", :b => nil }], parser.parse_command('foo a: "hello, world"')[]
  end

  private

  def commands
    cmd = Command.new("foo", "", [], [CommandParam.new(:a), CommandParam.new(:b)]) { |*args| args }
    cmds = [cmd]
    def cmds.find_by_name_or_alias(name); first; end
    cmds
  end

  def parser
    InputParser.new(commands)
  end
end


