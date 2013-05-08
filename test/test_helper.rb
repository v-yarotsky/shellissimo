require 'rubygems'

if ENV["COVERAGE"]
  require 'simplecov'
  SimpleCov.start
elsif ENV["TRAVIS"]
  require 'coveralls'
  Coveralls.wear!
end

require 'minitest/unit'
require 'minitest/pride'

$:.unshift File.expand_path('../../lib', __FILE__)

class FacebokrTestCase < MiniTest::Unit::TestCase
  def self.test(name, &block)
    raise ArgumentError, "Example name can't be empty" if String(name).empty?
    block ||= proc { skip "Not implemented yet" }
    define_method "test #{name}", &block
  end
end

require 'minitest/autorun'

