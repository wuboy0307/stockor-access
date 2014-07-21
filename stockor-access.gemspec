# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stockor/access/version'

Gem::Specification.new do |spec|
  spec.name          = "stockor-access"
  spec.version       = Stockor::Access::VERSION
  spec.authors       = ["Nathan Stitt"]
  spec.email         = ["nathan@stitt.org"]
  spec.summary       = %q{Access control for Stockor API}
  spec.description   = %q{Access control for Stockor API via a user model and role based access}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "bcrypt-ruby", "~>3.1.5"
  spec.add_dependency "stockor-core", "0.2"
  spec.add_dependency "stockor-api", "0.2"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
