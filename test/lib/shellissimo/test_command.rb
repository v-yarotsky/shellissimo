require 'test_helper'
require 'shellissimo/command'
require 'ostruct'

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

  test "#prepend_params return command copy with curried block" do
    received_params = {}
    c = command("foo") { |params| received_params = params }
    c = c.prepend_params(:foo => 1, :bar => 2)
    c.call
    assert_equal ({ :foo => 1, :bar => 2 }), received_params
  end

  test "#prepend_params runs validations over params" do
    param_definition = sample_param_definition
    def param_definition.valid?(*); false; end
    c = command("foo", "", [], [param_definition]) { |params| received_params = params }
    assert_raises ArgumentError do
      c.prepend_params(:removed => 1, :bar => 2)
    end
  end

  private

  def command(*args, &block)
    Command.new(*args, &block)
  end

  def sample_param_definition
    param_definition = OpenStruct.new(:name => :bar)
    def param_definition.valid?(*); true; end
    param_definition
  end
end

