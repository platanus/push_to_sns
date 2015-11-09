# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'push_to_sns/version'

Gem::Specification.new do |spec|
  spec.name          = "push_to_sns"
  spec.version       = PushToSNS::VERSION
  spec.authors       = ["juliogarciag"]
  spec.email         = ["julioggonz@gmail.com"]

  spec.summary       = %q{Organized SNS Push Notifications for Ruby.}
  spec.description   = %q{Organized SNS Push Notifications for Ruby.}
  spec.homepage      = "https://github.com/platanus/push_to_sns"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.3"
  spec.add_development_dependency "guard", "~> 2.13"
  spec.add_development_dependency "guard-rspec", "~> 4.6"
  spec.add_development_dependency "rspec-nc", "~> 0.2"
  spec.add_development_dependency "rspec-legacy_formatters", "~> 1.0"
  spec.add_runtime_dependency "deep_merge","~> 1.0"
end
