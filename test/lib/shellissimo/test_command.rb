require 'test_helper'
require 'shellissimo/command'

include Shellissimo

class TestCommand < ShellissimoTestCase
  test "has name as an CommandName instance" do
    assert_instance_of CommandName, command("hello") { |*| }.name
  end

  test "can't be created without proc" do
    assert_raises ArgumentError, "command proc is required" do
      command("foo")
    end
  end

  test "is callable" do
    called = false
    c = command("foo") { |*| called = true }
    c.call
    assert called, "expected command block to be called"
  end

  private

  def command(*args, &block)
    Command.new(*args, &block)
  end
end

