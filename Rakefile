require "bundler/gem_tasks"
require "yard"
require "yard/rake/yardoc_task"
require "rake/testtask"

desc "generate YARD documentation"
YARD::Rake::YardocTask.new(:doc) do |t|
  t.files = FileList['lib/**/*.rb']
end

desc "run unit tests"
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/lib/**/test*.rb']
end

task :default => :test
