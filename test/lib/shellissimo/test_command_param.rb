require 'test_helper'
require 'shellissimo/command_param'

include Shellissimo

class TestCommandParam < ShellissimoTestCase
  test "can't be created without name" do
    assert_raises ArgumentError, "command param name can't be blank" do
      param(nil)
    end
  end

  test "can have a description" do
    assert_equal "foo desc", param("foo", :noop, "foo desc").description
  end

  test "is always valid by default" do
    assert param("foo").valid?(:literally_anything), "expected param to be valid by default"
  end

  test "param name is a symbol" do
    assert_equal :foo, param("foo").name
  end

  private

  def param(*args)
    CommandParam.new(*args)
  end
end

