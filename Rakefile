require "bundler/gem_tasks"
require 'rake/testtask'

desc "run unit tests"
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/lib/**/test*.rb']
end

task :default => :test
