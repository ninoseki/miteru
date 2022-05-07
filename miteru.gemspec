# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "miteru/version"

Gem::Specification.new do |spec|
  spec.name = "miteru"
  spec.version = Miteru::VERSION
  spec.authors = ["Manabu Niseki"]
  spec.email = ["manabu.niseki@gmail.com"]

  spec.summary = "An experimental phishing kit detector"
  spec.description = "An experimental phishing kit detector"
  spec.homepage = "https://github.com/ninoseki/miteru"
  spec.license = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.3"
  spec.add_development_dependency "coveralls_reborn", "~> 0.24"
  spec.add_development_dependency "glint", "~> 0.1"
  spec.add_development_dependency "mysql2", "~> 0.5"
  spec.add_development_dependency "overcommit", "~> 0.59"
  spec.add_development_dependency "pg", "~> 1.3"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.11"
  spec.add_development_dependency "standard", "~> 1.11"
  spec.add_development_dependency "vcr", "~> 6.1"
  spec.add_development_dependency "webmock", "~> 3.14"
  spec.add_development_dependency "webrick", "~> 1.7.0"

  spec.add_dependency "activerecord", "~> 7.0"
  spec.add_dependency "colorize", "~> 0.8"
  spec.add_dependency "down", "~> 5.3"
  spec.add_dependency "http", "~> 5.0"
  spec.add_dependency "oga", "~> 3.3"
  spec.add_dependency "parallel", "~> 1.22"
  spec.add_dependency "slack-notifier", "~> 2.4"
  spec.add_dependency "sqlite3", "~> 1.4"
  spec.add_dependency "thor", "~> 1.2"
  spec.add_dependency "urlscan", "~> 0.8"
  spec.add_dependency "uuidtools", "~> 2.2"
end
