# frozen_string_literal: true

# Core standard libraries
require "cgi"
require "json"
require "uri"
require "uuidtools"

# Core 3rd party libraries
require "colorize"
require "memo_wise"
require "semantic_logger"
require "sentry-ruby"

require "dry/files"
require "dry/monads"

# Load .env
require "dotenv/load"

# Active Support & Active Record
require "active_support"
require "active_record"

# Version
require "miteru/version"
# Errors
require "miteru/errors"

# Concerns
require "miteru/concerns/database_connectable"
require "miteru/concerns/error_unwrappable"
require "miteru/concerns/url_truncatable"

# Helpers
require "miteru/helpers"

# Core classes
require "miteru/service"

require "miteru/cache"
require "miteru/config"
require "miteru/http"

# Database + ActiveRecord
require "miteru/database"
require "miteru/record"

module Miteru
  class << self
    prepend MemoWise

    #
    # @return [SematicLogger]
    #
    def logger
      SemanticLogger.default_level = :info
      SemanticLogger.add_appender(io: $stderr, formatter: :color)
      SemanticLogger["Miteru"]
    end
    memo_wise :logger

    #
    # @return [Array<Miteru::Feeds::Base>]
    #
    def feeds
      []
    end
    memo_wise :feeds

    #
    # @return [Array<Miteru::Notifiers::Base>]
    #
    def notifiers
      []
    end
    memo_wise :notifiers

    #
    # @return [Miteru::Config]
    #
    def config
      @config ||= Config.new
    end

    #
    # @return [String]
    #
    def env
      ENV["APP_ENV"] || ENV["RACK_ENV"]
    end

    #
    # @return [Boolean]
    #
    def development?
      env == "development"
    end

    def cache?
      !Miteru.config.cache_redis_url.nil?
    end

    def cache
      @cache ||= Cache.new(Miteru.config.cache_redis_url)
    end

    def sentry?
      !Miteru.config.sentry_dsn.nil?
    end

    def initialize_sentry
      return if Sentry.initialized?

      Sentry.init do |config|
        config.dsn = Miteru.config.sentry_dsn
        config.traces_sample_rate = Miteru.config.sentry_trace_sample_rate
        config.breadcrumbs_logger = %i[sentry_logger http_logger]
      end
    end
  end
end

# Services
require "miteru/crawler"
require "miteru/downloader"
require "miteru/kit"
require "miteru/orchestrator"
require "miteru/website"

# Notifiers
require "miteru/notifiers/base"
require "miteru/notifiers/slack"
require "miteru/notifiers/urlscan"

# Feeds
require "miteru/feeds/base"

require "miteru/feeds/ayashige"
require "miteru/feeds/phishing_database"
require "miteru/feeds/tweetfeed"
require "miteru/feeds/urlscan_pro"
require "miteru/feeds/urlscan"

# CLI
require "miteru/cli/application"

# Sidekiq
require "sidekiq"

require "miteru/sidekiq/application"
require "miteru/sidekiq/jobs"

Miteru.initialize_sentry if Miteru.sentry?
