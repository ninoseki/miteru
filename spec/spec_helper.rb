# frozen_string_literal: true

require "bundler/setup"

require "simplecov"
require "vcr"

def ci_env?
  # CI=true in GitHub Actions
  ENV["CI"]
end

# setup simplecov formatter for coveralls
class InceptionFormatter
  def format(result)
    Coveralls::SimpleCov::Formatter.new.format(result)
  end
end

def formatter
  if ENV["CI"] || ENV["COVERALLS_REPO_TOKEN"]
    if ENV["GITHUB_ACTIONS"]
      SimpleCov::Formatter::MultiFormatter.new([InceptionFormatter, SimpleCov::Formatter::LcovFormatter])
    else
      InceptionFormatter
    end
  else
    SimpleCov::Formatter::HTMLFormatter
  end
end

def setup_formatter
  if ENV["GITHUB_ACTIONS"]
    require "simplecov-lcov"

    SimpleCov::Formatter::LcovFormatter.config do |c|
      c.report_with_single_file = true
      c.single_report_path = "coverage/lcov.info"
    end
  end
  SimpleCov.formatter = formatter
end

setup_formatter

SimpleCov.start do
  add_filter do |source_file|
    source_file.filename.include?("spec") && !source_file.filename.include?("fixture")
  end
  add_filter %r{/.bundle/}
end

require "coveralls"

# Use in-memory SQLite in local test
ENV["DATABASE_URL"] = "sqlite3::memory:" unless ci_env?

require "miteru"

require "test_prof/recipes/rspec/let_it_be"

require_relative "support/shared_contexts/fake_http_server_context"
require_relative "support/shared_contexts/mocked_logger_context"

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.configure_rspec_metadata!
  config.ignore_localhost = true
  config.filter_sensitive_data("<CENSORED/>") { ENV["URLSCAN_API_KEY"] }
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.order = "random"

  config.before(:suite) do
    Miteru::Database.connect

    ActiveRecord::Migration.verbose = false
    Miteru::Database.migrate :up
  end

  config.after(:suite) do
    Miteru::Database.close
  end
end
