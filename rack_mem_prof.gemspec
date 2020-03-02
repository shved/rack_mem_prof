# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/mem_prof/version'

Gem::Specification.new do |spec|
  spec.name          = 'rack_mem_prof'
  spec.version       = Rack::MemProf::VERSION
  spec.authors       = ['Vitaly Shvedchenko']
  spec.email         = ['vitaly.shvedchenko@gmail.com']
  spec.summary       = 'Rack memory profiling middleware'
  spec.description   = "Sam Saffron's memory profiler made up as a rack middleware that writes reports to tmp folder"
  spec.homepage      = 'https://github.com/shved/rack_mem_prof'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split("\n")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'rack'
  spec.add_dependency 'memory_profiler', '~> 0.9'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rack-test', '~> 1.1'
  spec.add_development_dependency 'test-unit', '~> 3.3'
  spec.add_development_dependency 'roda', '~> 3.29'
  spec.add_development_dependency 'mocha', '~> 1.11'
  spec.add_development_dependency 'pry-byebug'
end


