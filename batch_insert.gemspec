# -*- encoding: utf-8 -*-
require File.expand_path('../lib/batch_insert/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Shaun Mangelsdorf"]
  gem.email         = ["s.mangelsdorf@gmail.com"]
  gem.description   = %q{Adds batch insertion capabilities to ActiveRecord model classes.}
  gem.summary       = %q{Extends ActiveRecord to provide batch insertion capabilities}

  gem.homepage      = "http://github.com/smangelsdorf/batch_insert"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "batch_insert"
  gem.require_paths = ["lib"]
  gem.version       = BatchInsert::VERSION
end
