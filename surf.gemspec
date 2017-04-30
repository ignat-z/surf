# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'surf/version'

Gem::Specification.new do |spec|
  spec.name          = 'surf'
  spec.version       = Surf::VERSION
  spec.authors       = ['Ignat Zakrevsky']
  spec.email         = ['iezakrevsky@gmail.com']

  spec.summary       = 'Gem'
  spec.homepage      = 'https://github.com/ignat-zakrevsky/surf'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rack', '>= 1.5.2', '< 2.0.0'
  spec.add_runtime_dependency 'octokit'
  spec.add_runtime_dependency 'redis'
  spec.add_runtime_dependency 'puma', '>= 2.7.1'
  spec.add_runtime_dependency "thor", ">= 0.18.1"
  spec.add_runtime_dependency "i18n"

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'mock_redis'
  spec.add_development_dependency "awesome_print"
  spec.add_development_dependency "m", "~> 1.5.0"
end
