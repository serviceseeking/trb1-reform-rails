# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'trb1-reform/rails/version'

Gem::Specification.new do |spec|
  spec.name          = "trb1-reform-rails"
  spec.version       = Trb1::Reform::Rails::VERSION
  spec.authors       = ["Nick Sutterer"]
  spec.email         = ["apotonick@gmail.com"]

  spec.summary       = %q{Automatically load and include all common Rails form features.}
  spec.description   = %q{Automatically load and include all common Reform features for a standard Rails environment.}
  spec.homepage      = "https://github.com/trailblazer/reform-rails"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "trb1-reform", ">= 2.2.0.rc1"
  spec.add_dependency "activemodel", ">= 3.2"

  spec.add_development_dependency "rails"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "actionpack"
  spec.add_development_dependency "activerecord"
  spec.add_development_dependency "mongoid"
  spec.add_development_dependency "sqlite3"
end
