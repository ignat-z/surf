# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'
require "rubocop/rake_task"

RuboCop::RakeTask.new do |task|
  task.options = ['--auto-correct']
end

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

default_tasks = ENV['FULL'].nil? ? [:test] : [:test, :rubocop]
task default: default_tasks
