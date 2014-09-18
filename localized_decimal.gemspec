# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'localized_decimal/version'

Gem::Specification.new do |spec|
  spec.name          = "localized_decimal"
  spec.version       = LocalizedDecimal::VERSION
  spec.authors       = ["Tilo Dietrich"]
  spec.email         = ["tilo.dietrich@posteo.de"]
  spec.summary       = %q{Localize decimal attributes in ActiveModel}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/tilod/localize_decimal"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = []
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
