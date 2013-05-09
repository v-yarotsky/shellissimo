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

  test "mandatory is not valid if nil" do
    refute param("foo", :mandatory).valid?(nil), "expected mandatory param not to be valid by if nil"
  end

  test "mandatory is valid if non-nil" do
    assert param("foo", :mandatory).valid?(1), "expected mandatory param to be valid by if non-nil"
  end

  test "mandatory allows additional validation" do
    assert param("foo", :mandatory) { |v| v == 1 }.valid?(1), "expected mandatory param to respect additional validations"
  end

  test "mandatory requiress non-nil value with custom validation" do
    refute param("foo", :mandatory) { |v| true }.valid?(nil), "expected mandatory param not to be valid if nil even if additional validation is ok"
  end

  test "param name is a symbol" do
    assert_equal :foo, param("foo").name
  end

  private

  def param(*args, &block)
    CommandParam.new(*args, &block)
  end
end

