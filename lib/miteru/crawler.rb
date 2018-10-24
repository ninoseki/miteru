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
      @post_to_slack = post_to_slack
      @size = size
      @threads = threads
      @verbose = verbose

      @feeds = Feeds.new(size, directory_traveling: directory_traveling)
    end

    def execute
      puts "Loaded #{feeds.suspicious_urls.length} URLs to crawl." if verbose

      Parallel.each(feeds.suspicious_urls, in_threads: threads) do |url|
        website = Website.new(url)
        if website.has_kit?
          message = "#{website.url}: it might contain phishing kit(s) (#{website.compressed_files.join(', ')})."
          puts message.colorize(:light_red)
          post_a_message_to_slack(message) if post_to_slack? && valid_slack_setting?
          downloader.download_compressed_files(website.url, website.compressed_files) if auto_download?
        else
          puts "#{website.url}: it doesn't contain a phishing kit." if verbose
        end
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

    def post_a_message_to_slack(message)
      webhook_url = ENV["SLACK_WEBHOOK_URL"]
      raise ArgumentError, "Please set the Slack webhook URL via SLACK_WEBHOOK_URL env" unless webhook_url

      channel = ENV["SLACK_CHANNEL"] || "#general"

      payload = { text: message, channel: channel }
      HTTPClient.post(webhook_url, json: payload)
    end

    def post_to_slack?
      @post_to_slack
    end

    def auto_download?
      @auto_download
    end

    def valid_slack_setting?
      ENV["SLACK_WEBHOOK_URL"] != nil
    end


  end
end
