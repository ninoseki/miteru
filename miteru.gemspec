# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "miteru/version"

Gem::Specification.new do |spec|
  spec.name          = "miteru"
  spec.version       = Miteru::VERSION
  spec.authors       = ["Manabu Niseki"]
  spec.email         = ["manabu.niseki@gmail.com"]

  spec.summary       = "An experimental phishing kit detector"
  spec.description   = "An experimental phishing kit detector"
  spec.homepage      = "https://github.com/ninoseki/miteru"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "coveralls", "~> 0.8"
  spec.add_development_dependency "glint", "~> 0.1"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.9"
  spec.add_development_dependency "vcr", "~> 6.0"
  spec.add_development_dependency "webmock", "~> 3.9"

  spec.add_dependency "colorize", "~> 0.8"
  spec.add_dependency "down", "~> 5.2"
  spec.add_dependency "http", "~> 4.4"
  spec.add_dependency "oga", "~> 3.3"
  spec.add_dependency "parallel", "~> 1.19"
  spec.add_dependency "slack-notifier", "~> 2.3"
  spec.add_dependency "thor", "~> 1.0"
  spec.add_dependency "urlscan", "~> 0.6"
end
