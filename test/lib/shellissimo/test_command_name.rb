require 'test_helper'
require 'shellissimo/command_name'

include Shellissimo

class TestCommandName < ShellissimoTestCase
  test "can not be created with blank name" do
    assert_raises ArgumentError, "command name can't be blank" do
      command_name(nil)
    end
  end

  test "is equal to itself" do
    n = command_name("foo")
    assert_equal n, n
  end

  test "instances are equal if name and aliases are equal" do
    assert_equal command_name("foo"), command_name("foo")
    assert_equal command_name("foo", ["baz"]), command_name("foo", ["baz"])
  end

  test "instances are not equal if names aren't equal" do
    refute_equal command_name("foo"), command_name("bar")
  end

  test "instances are not equal if aliases aren't equal" do
    refute_equal command_name("foo", ["baz"]), command_name("foo", ["qux"])
  end

  test "is equal to a string if the string is a command's name" do
    assert_equal command_name("foo"), "foo"
  end

  test "is equal to a string if it is one of command's aliases" do
    assert_equal command_name("foo", ["bar", "baz"]), "bar"
    assert_equal command_name("foo", ["bar", "baz"]), "baz"
  end

  test "is not equal to a string that is neither name nor an alias" do
    refute_equal command_name("foo", ["bar", "baz"]), "qux"
  end

  test "is not equal to crap" do
    refute_equal command_name("foo"), 1
  end

  test "is sorted by name" do
    assert command_name("foo") > command_name("bar"), "expected 'foo' to be greater than 'bar'"
    assert command_name("bar") < command_name("baz"), "expected 'bar' to be less than 'baz'"
  end

  test "#to_s returns name (bright)" do
    assert_equal "\e[1mfoo\e[0m", command_name("foo").to_s
  end

  test "#to_s returns name (bright) and aliases if present" do
    assert_equal "\e[1mfoo\e[0m (aliases: f, q)", command_name("foo", ["f", "q"]).to_s
  end

  private

  def command_name(*args)
    CommandName.new(*args)
  end
end

