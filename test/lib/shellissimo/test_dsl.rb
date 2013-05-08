require 'test_helper'
require 'shellissimo/dsl'

include Shellissimo

class TestDsl < ShellissimoTestCase
  test ".command creates a command" do
    assert fake_with_command_foo.commands.find_by_name_or_alias("foo"), "expected command 'foo' to be defined"
  end

  test "#run inside .command sets command block" do
    assert_equal :hello, fake_with_command_foo.commands.find_by_name_or_alias("foo").call
  end

  test "#shortcut inside .command sets command aliases" do
    assert fake_with_command_foo.commands.find_by_name_or_alias("f"), "expected command 'foo' to be found by alias 'f'"
  end

  test "#description inside .command sets command description" do
    assert_equal "foo description", fake_with_command_foo.commands.find_by_name_or_alias("foo").description
  end

  private

  def fake_with_command_foo
    fake do
      command :foo do |c|
        c.shortcut :f
        c.description "foo description"
        c.run { :hello }
      end
    end
  end

  def fake(*args, &block)
    Class.new do
      include DSL
      instance_eval(&block)
    end
  end
end

