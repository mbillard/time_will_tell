# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'time_will_tell/version'

Gem::Specification.new do |spec|
  spec.name          = "time_will_tell"
  spec.version       = TimeWillTell::VERSION
  spec.authors       = ["Michel Billard"]
  spec.email         = ["michel@mbillard.com"]
  spec.summary       = %q{Specialized conversions of dates and times to strings.}
  # spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = "http://github.com/mbillard/time_will_tell"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "railties", ">= 3.2"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
