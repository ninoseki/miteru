# frozen_string_literal: true

require "memist"
require "semantic_logger"

require "miteru/version"

require "miteru/configuration"
require "miteru/database"

require "miteru/record"

require "miteru/mixin"

require "miteru/notifiers/base"
require "miteru/notifiers/slack"
require "miteru/notifiers/urlscan"

require "miteru/error"
require "miteru/http_client"
require "miteru/kit"
require "miteru/website"
require "miteru/downloader"
require "miteru/feeds"
require "miteru/attachement"
require "miteru/crawler"
require "miteru/cli"

# Load .env
require "dotenv/load"

module Miteru
  class << self
    include Memist::Memoizable
    def logger
      SemanticLogger.default_level = :info
      SemanticLogger.add_appender(io: $stderr, formatter: :color)
      SemanticLogger["Miteru"]
    end
    memoize :logger
  end
end
