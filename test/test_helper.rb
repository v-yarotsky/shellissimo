require 'rubygems'
require 'bundler/setup'

lib = File.expand_path('../../lib', __FILE__)
$:.unshift lib

if ENV["COVERAGE"]
  require 'simplecov'
  if ENV["TRAVIS"]
    require 'coveralls'
    SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  end
  SimpleCov.start do
    add_filter "/test/"
  end
  Dir.glob(File.join(lib, "**", "*.rb")).each { |f| require f }
end

require 'minitest/unit'
require 'minitest/reporters'

MiniTest::Reporters.use! MiniTest::Reporters::SpecReporter.new

class ShellissimoTestCase < MiniTest::Unit::TestCase
  def self.test(name, &block)
    raise ArgumentError, "Example name can't be empty" if String(name).empty?
    block ||= proc { skip "Not implemented yet" }
    define_method "test #{name}", &block
  end
end

require 'minitest/autorun'

