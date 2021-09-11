# frozen_string_literal: true

require_relative "./feeds/feed"
require_relative "./feeds/phishing_database"
require_relative "./feeds/phishstats"
require_relative "./feeds/ayashige"
require_relative "./feeds/urlscan"
require_relative "./feeds/urlscan_pro"

module Miteru
  class Entry
    # @return [String]
    attr_reader :url
    # @return [String]
    attr_reader :source

    def initialize(url, source)
      @url = url
      @source = source
    end
  end

  class Feeds
    IGNORE_EXTENSIONS = %w[.htm .html .php .asp .aspx .exe .txt].freeze

    def initialize
      @feeds = [
        PhishingDatabase.new,
        PhishStats.new,
        UrlScan.new(Miteru.configuration.size),
        UrlScanPro.new,
        Miteru.configuration.ayashige? ? Ayashige.new : nil
      ].compact
    end

    #
    # Returns a list of suspicious entries
    #
    # @return [Array<Entry>]
    #
    def suspicious_entries
      @suspicious_entries ||= @feeds.map(&:entries).flatten.uniq(&:url)
    end
  end
end
