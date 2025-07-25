# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "miteru/version"

Gem::Specification.new do |spec|
  spec.name = "miteru"
  spec.version = Miteru::VERSION
  spec.authors = ["Manabu Niseki"]
  spec.email = ["manabu.niseki@gmail.com"]
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.summary = "A phishing kit collector for scavengers"
  spec.description = "A phishing kit collector for scavengers"
  spec.homepage = "https://github.com/ninoseki/miteru"
  spec.license = "MIT"

  spec.required_ruby_version = ">= 3.2"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.5"
  spec.add_development_dependency "capybara", "~> 3.40"
  spec.add_development_dependency "coveralls_reborn", "~> 0.28"
  spec.add_development_dependency "fuubar", "~> 2.5.1"
  spec.add_development_dependency "mysql2", "~> 0.5.6"
  spec.add_development_dependency "pg", "~> 1.5.9"
  spec.add_development_dependency "rake", "~> 13.3.0"
  spec.add_development_dependency "rspec", "~> 3.13.1"
  spec.add_development_dependency "simplecov-lcov", "~> 0.8"
  spec.add_development_dependency "standard", "~> 1.50.0"
  spec.add_development_dependency "test-prof", "~> 1.4.4"
  spec.add_development_dependency "vcr", "~> 6.3.1"
  spec.add_development_dependency "webmock", "~> 3.25.1"

  spec.add_dependency "activerecord", "8.0.2"
  spec.add_dependency "addressable", "2.8.7"
  spec.add_dependency "anyway_config", "2.7.2"
  spec.add_dependency "colorize", "1.1.0"
  spec.add_dependency "dotenv", "3.1.8"
  spec.add_dependency "down", "5.4.2"
  spec.add_dependency "dry-files", "1.1.0"
  spec.add_dependency "dry-monads", "1.8.3"
  spec.add_dependency "http", "5.2.0"
  spec.add_dependency "memo_wise", "1.13.0"
  spec.add_dependency "oga", "3.4"
  spec.add_dependency "puma", "6.6.0"
  spec.add_dependency "rack", "3.1.16"
  spec.add_dependency "rack-session", "2.1.1"
  spec.add_dependency "rackup", "2.2.1"
  spec.add_dependency "redis", "5.4.0"
  spec.add_dependency "semantic_logger", "4.16.1"
  spec.add_dependency "sentry-ruby", "5.24.0"
  spec.add_dependency "sentry-sidekiq", "5.24.0"
  spec.add_dependency "sidekiq", "8.0.4"
  spec.add_dependency "slack-notifier", "2.4.0"
  spec.add_dependency "sqlite3", "2.6.0"
  spec.add_dependency "thor", "1.3.2"
  spec.add_dependency "thor-hollaback", "0.2.1"
  spec.add_dependency "uuidtools", "3.0.0"
end
