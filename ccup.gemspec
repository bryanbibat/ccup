# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ccup/version'

Gem::Specification.new do |gem|
  gem.name          = "ccup"
  gem.version       = Ccup::VERSION
  gem.authors       = ["Bryan Bibat"]
  gem.email         = ["bry@bryanbibat.net"]
  gem.description   = %q{Verification tool for DevCon Code Challenge Cup}
  gem.summary       = %q{This automates stuff.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "guard"
  gem.add_development_dependency "guard-rspec"
  gem.add_development_dependency "libnotify"
  gem.add_development_dependency "rb-inotify"
  gem.add_runtime_dependency "open4"

end
