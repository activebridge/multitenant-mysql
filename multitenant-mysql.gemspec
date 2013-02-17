# -*- encoding: utf-8 -*-
require File.expand_path('../lib/multitenant-mysql/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Eugene Korpan"]
  gem.email         = ["korpan.eugene@gamil.com"]
  gem.description   = %q{Integrates multi-tenancy into Rail application with MySql db}
  gem.summary       = %q{Add multi-tenancy to Rails application using MySql views}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "multitenant-mysql"
  gem.require_paths = ["lib"]
  gem.version       = Multitenant::Mysql::VERSION

  gem.add_development_dependency "rspec"
end
