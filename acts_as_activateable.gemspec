# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'acts_as_activateable/version'

Gem::Specification.new do |spec|
  spec.name          = "acts_as_activateable"
  spec.version       = ActsAsActivateable::VERSION
  spec.authors       = ["Caleb Adam Haye"]
  spec.email         = ["caleb@fire.coop"]
  spec.description   = %q{Simple activation gem}
  spec.summary       = %q{Convenience methods for turning things on and off.}
  spec.homepage      = "http://github.com/presskit/acts_as_activateable"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
