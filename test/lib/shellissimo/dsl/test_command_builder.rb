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

  test "#param creates a param" do
    assert_includes builder("foo") { |c| c.param("bar") }.result.param_definitions.map(&:name), :bar
  end

  test "#param yields CommandParamBuilder" do
    param_builder = nil
    builder("foo") { |c| c.param("bar") { |p| param_builder = p } }
    assert_instance_of CommandParamBuilder, param_builder
  end

  test "#param returns CommandParam" do
    param = nil
    builder("foo") { |c| param = c.param("bar") }
    assert_instance_of Shellissimo::CommandParam, param
  end

  test "#mandatory_param yields builder with presence validator" do
    fake_param_builder = Class.new do
      attr_reader :mandatory
      def initialize(*); @mandatory = false; end
      def mandatory!;    @mandatory = true;  end
      def result;                            end
    end
    param_builder = nil
    builder("foo", fake_param_builder) { |c| c.mandatory_param("bar") { |p| param_builder = p } }
    assert param_builder.mandatory, "expected param to be built as mandatory"
  end

  private

  def builder(name, *args)
    c = CommandBuilder.new(name, *args)
    c.run {}
    yield c if block_given?
    c
  end
end


