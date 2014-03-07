lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tomify/version'

Gem::Specification.new do |spec|
  spec.name          = "tomify"
  spec.version       = Tomify::VERSION
  spec.author        = "Tom Prats"
  spec.email         = "tom@tomprats.com"
  spec.description   = %q{Traitify Developer Gem}
  spec.summary       = spec.description
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 0.8.0"
  spec.add_dependency "faraday_middleware", "~> 0.9.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 10.1.0"
  spec.add_development_dependency "rspec", "~> 2.14.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "binding_of_caller"
  spec.add_development_dependency "webmock", "~> 1.13.0"
end
