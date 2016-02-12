require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'reek/rake/task'
require 'flog'
require 'flog_task'
require 'flay'
require 'flay_task'

FlogTask.new :flog
FlayTask.new :flay

RSpec::Core::RakeTask.new(:spec)

RSpec::Core::RakeTask.new(:heckle) do |t|
  t.rspec_opts = '--heckle'
end

desc 'Run RuboCop on the lib directory'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = ['lib/**/*.rb']
  # only show the files with failures
  task.formatters = ['files']
  # don't abort rake on failure
  task.fail_on_error = false
end

Reek::Rake::Task.new do |t|
  t.fail_on_error = false
end

task quality: [:rubocop, :reek, :flog, :flay, :heckle]

task default: [:spec, :rubocop, :reek, :flog, :flay, :heckle]
