lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "traitify/version"

Gem::Specification.new do |spec|
  spec.name          = "traitify"
  spec.version       = Traitify::VERSION
  spec.licenses      = ["MIT"]
  spec.summary       = "Traitify Gem"
  spec.description   = "Traitify is a ruby gem wrapper for the Traitify API"
  spec.authors       = ["Tom Prats", "Eric Fleming"]
  spec.email         = "tom@traitify.com"
  spec.homepage      = "https://www.traitify.com"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "hashie", "~> 3.0"
  spec.add_dependency "faraday", "~> 0.9"
  spec.add_dependency "faraday_middleware", "~> 0.9"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "binding_of_caller", "~> 0.7"
  spec.add_development_dependency "webmock", "~> 1.13"
end
