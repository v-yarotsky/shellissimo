require 'test_helper'
require 'shellissimo/dsl/command_param_builder'

include Shellissimo::DSL

class TestCommandParamBuilder < ShellissimoTestCase
  test "sets command param name" do
    assert_equal builder("foo").result.name, :foo
  end

  test "#description sets command param description" do
    assert_equal "bar", builder("foo") { |c| c.description "bar" }.result.description
  end

  test "#mandatory! sets stock validator to mandatory" do
    refute builder("foo") { |c| c.mandatory! }.result.valid?(nil), "expected param to be mandatory"
  end

  test "#validate sets validator" do
    called = false
    param = builder("foo") { |c| c.validate { |v| called = true } }.result
    param.valid?(:anything)
    assert called, "expected validation block to be set"
  end

  private

  def builder(name)
    c = CommandParamBuilder.new(name)
    yield c if block_given?
    c
  end
end


