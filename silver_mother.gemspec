# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'silver_mother/version'

Gem::Specification.new do |spec|
  spec.name          = 'silver_mother'
  spec.version       = SilverMother::VERSION
  spec.authors       = ['Mark Kreyman']
  spec.email         = ['mark@kreyman.com']

  spec.summary       = 'A library for communicating with the SilverMother API.'
  spec.description   = 'A ruby library for communicating with the SilverMother \
                        REST API. Register your application at \
                        https://sen.se/developers/'

  spec.homepage      = 'https://github.com/mkreyman/silver_mother'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`
                       .split("\x0")
                       .reject { |f| f.match(%r{^(test|spec|features)/}) }

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.13.6'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'webmock'

  spec.add_dependency 'httparty', '~> 0.14.0'
end
