require 'rake'
require 'rake/testtask'
require 'rdoc/task'
require 'rspec/core/rake_task'

desc 'Default: run unit tests.'
task :default => :test

desc 'Generate documentation for the batch_insert plugin.'
RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'BatchInsert'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = ["-c", "-f progress", "-r ./spec/spec_helper.rb"]
  t.pattern = 'spec/*_spec.rb'
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'batch_insert'
    gem.summary = 'Extends ActiveRecord to provide batch insertion capabilities'
    gem.description = 'Adds batch insertion capabilities to ActiveRecord model classes.'
    gem.files = Dir[
      '[a-zA-Z]*',
      'generators/**/*',
      'lib/**/*',
      'rails/**/*',
      'spec/**/*'
    ]
    gem.extra_rdoc_files = ['README.md']
    gem.authors = ['Shaun Mangelsdorf']
    gem.homepage = 'http://smangelsdorf.github.com'
    gem.version = '0.3'
  end
rescue LoadError
  puts "Jeweler could not be sourced"
end
