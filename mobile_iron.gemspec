# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mobile_iron/version'

Gem::Specification.new do |spec|
  spec.name          = "mobile_iron"
  spec.version       = MobileIron::VERSION
  spec.authors       = ["Lars Kuhnt"]
  spec.email         = ["lars.kuhnt@gmail.com"]

  spec.summary       = %q{A ruby lib for Mobile Iron}
  spec.description   = %q{A ruby library for communicating with the Mobile Iron API server}
  spec.homepage      = "https://www.github.com/Promptus/mobile_iron"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", "~> 0.10"
end
