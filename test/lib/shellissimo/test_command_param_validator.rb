require 'test_helper'
require 'shellissimo/command_param_validator'

include Shellissimo

class TestCommandParamValidator < ShellissimoTestCase
  test "can have a description" do
    assert_equal "foo desc", (validator("foo desc") {}).description
  end

  test "noop is always valid" do
    assert noop_validator[:literally_anything], "expected param to be valid by default"
  end

  test "mandatory is not valid if nil" do
    refute mandatory_validator[nil], "expected mandatory param not to be valid by if nil"
  end

  test "mandatory is valid if non-nil" do
    assert mandatory_validator[1], "expected mandatory param to be valid by if non-nil"
  end

  test "allows combining validator with logical &" do
    v = mandatory_validator & validator("custom") { |v| v.nil? || v == 1 }
    refute v[nil], "expected mandatory validator to work"
    refute v[2], "expected custom validator to work"
    assert v[1], "expected both validators to work"
  end

  test "allows combining validator with logical |" do
    v = validator("v1") { |v| v == 1 } | validator("v2") { |v| v == 2 }
    assert v[1], "expected first custom validator to work"
    assert v[2], "expected second custom validator to work"
    refute v[0], "expected not to do whats not expected :)"
  end

  private

  def validator(description, &block)
    CommandParamValidator.new(description, &block)
  end

  [:noop, :optioal, :mandatory].each do |kind|
    define_method "#{kind}_validator" do
      CommandParamValidator.public_send(kind)
    end
  end
end

