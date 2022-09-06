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

  spec.add_runtime_dependency "activesupport", ">= 5.1", "< 8.x"
  spec.add_runtime_dependency "faraday", "~> 2.5"
  spec.add_runtime_dependency "faraday-net_http", "~> 3.0"

  spec.add_development_dependency "binding_of_caller", "~> 1.0"
  spec.add_development_dependency "bundler", "~> 2.2"
  spec.add_development_dependency "pry", "~> 0.14"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.11"
  spec.add_development_dependency "simplecov", "~> 0.21.2"
  spec.add_development_dependency "webmock", "~> 3.18"
end
