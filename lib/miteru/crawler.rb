# frozen_string_literal: true

require "colorize"
require "parallel"
require "uri"

module Miteru
  class Crawler
    attr_reader :downloader, :feeds

    def initialize
      @downloader = Downloader.new(Miteru.configuration.download_to)
      @feeds = Feeds.new
    end

    def crawl(entry)
      website = Website.new(entry.url, entry.source)
      downloader.download_kits(website.kits) if website.has_kits? && auto_download?
      notify(website) if website.has_kits? || verbose?
    rescue OpenSSL::SSL::SSLError, HTTP::Error, Addressable::URI::InvalidURIError => _e
      nil
    end

    def execute
      suspicious_entries = feeds.suspicious_entries
      puts "Loaded #{suspicious_entries.length} URLs to crawl. (crawling in #{threads} threads)" if verbose?

      Parallel.each(suspicious_entries, in_threads: threads) do |entry|
        crawl entry
      end
    end

    def threads
      @threads ||= Miteru.configuration.threads
    end

    def notify(website)
      Parallel.each(notifiers) do |notifier|
        notifier.notify website
      end
    end

    def auto_download?
      Miteru.configuration.auto_download?
    end

    def verbose?
      Miteru.configuration.verbose?
    end

    private

    def notifiers
      @notifiers ||= [Notifiers::Slack.new, Notifiers::UrlScan.new].select(&:notifiable?)
    end

    class << self
      def execute
        new.execute
      end
    end
  end
end
