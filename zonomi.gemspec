# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zonomi/version'

Gem::Specification.new do |gem|
  gem.name          = "zonomi"
  gem.version       = Zonomi::VERSION
  gem.authors       = ["Ruby Cluster", "Vlad Alive"]
  gem.email         = ["gems@rubycluster.com"]
  gem.description   = %q{Zonomi API Ruby wrapper}
  gem.summary       = %q{Zonomi API Ruby wrapper}
  gem.homepage      = "http://github.com/rubycluster/zonomi"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "httparty", ">= 0"

  gem.add_development_dependency "guard"
  gem.add_development_dependency "guard-bundler"
  gem.add_development_dependency "guard-rspec"
  gem.add_development_dependency "rb-inotify", "~> 0.8.8"

  gem.add_development_dependency "rspec", "~> 2.6"
  gem.add_development_dependency "factory_girl"

end
