# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'uri/io/version'

Gem::Specification.new do |spec|
  spec.name          = 'uri-io'
  spec.version       = URI::IO::VERSION
  spec.authors       = ['Konstantin Gredeskoul']
  spec.email         = ['kigster@gmail.com']

  spec.summary       = %q{WIP: Provides IO semantics for various URI schemes}
  spec.description   = %q{WIP: Provides IO semantics for various URI schemes}
  spec.homepage      = 'https://github.com/kigster/uri-io'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec-its'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'codeclimate-test-reporter',"~> 1.0.0"
  spec.add_development_dependency 'rspec', '~> 3'
end
