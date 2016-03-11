# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'git/helpers/version'

Gem::Specification.new do |spec|
  spec.name          = 'git-helpers'
  spec.version       = Git::Helpers::VERSION
  spec.authors       = ['Kierran McPherson']
  spec.email         = ['kierranm@gmail.com']

  spec.summary       = 'A few helpful git commands to make life easier'
  spec.description   = <<-eof
    git-helpers is a library of helpful command extensions for git that will
    help make git workflow slightly faster, and hopefully a little more enjoyable.
  eof
  spec.homepage      = 'https://github.com/kierranm/git-helpers'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|\
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.has_rdoc      = 'yard'

  spec.add_runtime_dependency 'launchy', '~> 2.4'
  spec.add_runtime_dependency 'git', '~> 1.3'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.37'
  spec.add_development_dependency 'reek', '~> 3.10'
  spec.add_development_dependency 'yard', '~> 0.8.7'
  spec.add_development_dependency 'guard', '~> 2.13'
  spec.add_development_dependency 'guard-rspec', '~> 4.6'
end
