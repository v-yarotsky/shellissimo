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
    assert_equal [{ :a => "hello, world" }], parser.parse_command('foo "a": "hello, world"')[]
  end

  test "supports unquoted keys" do
    assert_equal [{ :a => "hello, world" }], parser.parse_command('foo a: "hello, world"')[]
  end

  private

  def commands
    { "foo" => Command.new("foo") { |*args| args } }
  end

  def parser
    InputParser.new(commands)
  end
end


