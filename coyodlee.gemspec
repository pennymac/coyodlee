# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'coyodlee/version'

Gem::Specification.new do |spec|
  spec.name          = "coyodlee"
  spec.version       = Coyodlee::VERSION
  spec.authors       = ["Daniel Dyba"]
  spec.email         = ["daniel.dyba@gmail.com"]

  spec.summary       = %q{A Ruby wrapper client for Envestnet's Yodlee API}
  spec.description   = %q{A Ruby wrapper client for Envestnet's Yodlee API. For details about the API endpoints, sign in to https://developer.yodlee.com}
  spec.homepage      = "https://github.com/pennymac/coyodlee"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rest-client", "~> 2.0"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "vcr", "~> 3.0"
  spec.add_development_dependency "webmock", '~> 3.1'
  spec.add_development_dependency "yard", '~> 0.9'
  spec.add_development_dependency "activesupport", '5.1'
  spec.add_development_dependency "travis", '~> 1.8'
end
