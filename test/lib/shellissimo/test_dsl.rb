require 'test_helper'
require 'shellissimo/dsl'

include Shellissimo

class TestDsl < ShellissimoTestCase
  test ".command creates a command" do
    f = dsl do
      command :foo do |c|
        c.run { :hello }
      end
    end
    assert f.commands["foo"], "expected command 'foo' to be defined"
  end

  test ".command yields a builder" do
    builder = nil
    dsl do
      command(:foo) { |c| c.run {}; builder = c }
    end
    assert_instance_of DSL::CommandBuilder, builder
  end

  private

  def dsl(*args, &block)
    Class.new do
      include DSL
      instance_eval(&block)
    end
  end
end

