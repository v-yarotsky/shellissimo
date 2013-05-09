require 'test_helper'
require 'shellissimo/commands_collection'
require 'ostruct'

include Shellissimo

class TestCommandsCollection < ShellissimoTestCase
  test "#find_by_name_or_alias returns command by name" do
    assert_equal command("foo"), collection(command("foo")).find_by_name_or_alias("foo")
  end

  test "#[] returns command by name" do
    assert_equal command("foo"), collection(command("foo"))["foo"]
  end

  test "is enumerable" do
    c = collection(command("foo"), command("bar"))
    assert_kind_of Enumerable, c
    assert_equal [command("bar")], c.select { |c| c.name == "bar" }
  end

  private

  def collection(*commands)
    result = CommandsCollection.new
    result.push *commands
  end

  def command(name)
    OpenStruct.new(:name => name)
  end
end

