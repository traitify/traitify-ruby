lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "English"
require "traitify/version"

Gem::Specification.new do |spec|
  spec.name          = "traitify"
  spec.version       = Traitify::VERSION
  spec.licenses      = ["MIT"]
  spec.summary       = "Traitify Gem"
  spec.description   = "Traitify is a ruby gem wrapper for the Traitify API"
  spec.authors       = ["Tom Prats", "Eric Fleming", "Carson Wright"]
  spec.email         = "tom@traitify.com"
  spec.homepage      = "https://www.traitify.com"

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}){ |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activesupport", ">= 5.1", "< 7.x"
  spec.add_runtime_dependency "faraday", "~> 0.9"
  spec.add_runtime_dependency "faraday_middleware", "~> 0.9"

  spec.add_development_dependency "bundler", "~> 2.2"
  spec.add_development_dependency "rake", "~> 12.3.3"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "binding_of_caller", "~> 0.7"
  spec.add_development_dependency "webmock", "~> 1.13"
  spec.add_development_dependency "guard", "~> 2.16", ">= 2.16.0"
  spec.add_development_dependency "guard-rspec", "~> 4.7", ">= 4.7.2"
end
