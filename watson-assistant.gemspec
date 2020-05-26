
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "watson/assistant/version"

Gem::Specification.new do |spec|
  spec.name          = "watson-assistant"
  spec.version       = Watson::Assistant::VERSION
  spec.authors       = ["alpha.netzilla"]
  spec.email         = ["alpha.netzilla@gmail.com"]

  spec.summary       = %q{Client library to use the IBM Watson Assistant service}
  spec.description   = %q{Client library to use the IBM Watson Assistant service}
  spec.homepage      = "https://github.com/alpha-netzilla/watson-assistant.git"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 12.3.3"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rest-client", "~> 2.0"
  spec.add_development_dependency "redis", "~> 3.3"
end
