require './lib/timeouter/version'

Gem::Specification.new 'timeouter', Timeouter::VERSION do |spec|
  spec.authors       = ['Samoilenko Yuri']
  spec.email         = ['kinnalru@gmail.com']
  spec.description   = spec.summary = 'Timeouter is advisory timeout helper without any background threads.'
  spec.homepage      = 'https://github.com/RnD-Soft/timeouter'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z lib/timeouter.rb lib/timeouter README.md LICENSE features`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.add_development_dependency 'bundler', '~> 2.0', '>= 2.0.1'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec_junit_formatter'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'simplecov-console'
  spec.add_development_dependency 'rubocop'
end

