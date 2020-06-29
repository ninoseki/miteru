# frozen_string_literal: true

require_relative "./feeds/feed"
require_relative "./feeds/phishing_database"
require_relative "./feeds/phishstats"
require_relative "./feeds/ayashige"
require_relative "./feeds/urlscan"
require_relative "./feeds/urlscan_pro"

module Miteru
  class Feeds
    IGNORE_EXTENSIONS = %w(.htm .html .php .asp .aspx .exe .txt).freeze

    def initialize
      @feeds = [
        PhishingDatabase.new,
        PhishStats.new,
        UrlScan.new(Miteru.configuration.size),
        UrlScanPro.new,
        Miteru.configuration.ayashige? ? Ayashige.new : nil
      ].compact
    end

    def directory_traveling?
      Miteru.configuration.directory_traveling?
    end

    def suspicious_urls
      @suspicious_urls ||= [].tap do |arr|
        urls = @feeds.map do |feed|
          feed.urls.select { |url| url.start_with?("http://", "https://") }
        end.flatten.uniq

        urls.map { |url| breakdown(url) }.flatten.uniq.sort.each { |url| arr << url }
      end
    end

    def breakdown(url)
      begin
        uri = URI.parse(url)
      rescue URI::InvalidURIError => _e
        return []
      end

      base = "#{uri.scheme}://#{uri.hostname}"
      return [base] unless directory_traveling?

      segments = uri.path.split("/")
      return [base] if segments.length.zero?

      urls = (0...segments.length).map { |idx| "#{base}#{segments[0..idx].join('/')}" }

      urls.reject do |breakdowned_url|
        # Reject a url which ends with specific extension names
        invalid_extension? breakdowned_url
      end
    end

    def invalid_extension?(url)
      IGNORE_EXTENSIONS.any? { |ext| url.end_with? ext }
    end
  end
end
