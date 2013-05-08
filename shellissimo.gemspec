# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shellissimo/version'

Gem::Specification.new do |gem|
  gem.name          = "shellissimo"
  gem.version       = Shellissimo::VERSION
  gem.authors       = ["Vladimir Yarotsky"]
  gem.email         = ["vladimir.yarotsky@gmail.com"]
  gem.summary       = %q{Minimalistic framework for constructing shell-like applications}
  gem.homepage      = "https://github.com/v-yarotsky/shellissimo"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.has_rdoc = "yard"

  gem.add_dependency("json")

  gem.add_development_dependency("yard")
  gem.add_development_dependency("redcarpet")
  gem.add_development_dependency("minitest")
end
