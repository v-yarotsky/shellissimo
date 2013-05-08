require 'test_helper'
require 'shellissimo/dsl/command_builder'

include Shellissimo::DSL

class TestCommandBuilder < ShellissimoTestCase
  test "sets command name" do
    assert_equal builder("foo").result.name, "foo"
  end

  test "#description sets command description" do
    assert_equal "bar", builder("foo") { |c| c.description "bar" }.result.description
  end

  test "#shortcut sets command aliases" do
    assert_equal builder("foo") { |c| c.shortcut :f }.result.name, "f"
  end

  test "#run sets command block" do
    assert_equal :hi, builder("foo") { |c| c.run { :hi } }.result.call
  end

  private

  def builder(name)
    c = CommandBuilder.new(name)
    c.run {}
    yield c if block_given?
    c
  end
end


