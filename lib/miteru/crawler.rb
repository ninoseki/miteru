# frozen_string_literal: true

require "colorize"
require "parallel"
require "uri"

module Miteru
  class Crawler
    attr_reader :auto_download
    attr_reader :directory_traveling
    attr_reader :downloader
    attr_reader :feeds
    attr_reader :size
    attr_reader :threads
    attr_reader :verbose

    def initialize(auto_download: false, directory_traveling: false, download_to: "/tmp", post_to_slack: false, size: 100, threads: 10, verbose: false)
      @auto_download = auto_download
      @directory_traveling = directory_traveling
      @downloader = Downloader.new(download_to)
      @size = size
      @threads = threads
      @verbose = verbose

      @feeds = Feeds.new(size, directory_traveling: directory_traveling)
      @notifier = Notifier.new(post_to_slack)
    end

    def execute
      puts "Loaded #{feeds.suspicious_urls.length} URLs to crawl." if verbose

      Parallel.each(feeds.suspicious_urls, in_threads: threads) do |url|
        website = Website.new(url)
        if website.has_kit?
          downloader.download_compressed_files(website.url, website.compressed_files) if auto_download?
          notify(website.url, website.compressed_files)
        else
          notify(website.url, website.compressed_files) if verbose
        end
      rescue OpenSSL::SSL::SSLError, HTTP::Error, LL::ParserError => _
        next
      end
    end

    def self.execute(auto_download: false, directory_traveling: false, download_to: "/tmp", post_to_slack: false, size: 100, threads: 10, verbose: false)
      new(
        auto_download: auto_download,
        directory_traveling: directory_traveling,
        download_to: download_to,
        post_to_slack: post_to_slack,
        size: size,
        threads: threads,
        verbose: verbose
      ).execute
    end

    def notify(url, message)
      @notifier.notify(url, message)
    end

    def auto_download?
      @auto_download
    end
  end
end
