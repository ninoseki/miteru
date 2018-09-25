# frozen_string_literal: true

require "http"
require "json"
require "thread/pool"
require "uri"

module Miteru
  class Crawler
    attr_reader :threads
    attr_reader :size
    attr_reader :verbose

    URLSCAN_ENDPOINT = "https://urlscan.io/api/v1"
    OPENPHISH_ENDPOINT = "https://openphish.com"

    def initialize(size: 100, verbose: false)
      @threads = 10
      @size = size
      @verbose = verbose
      raise ArgumentError, "size must be less than 100,000" if size > 100_000
    end

    def urlscan_feed
      url = "#{URLSCAN_ENDPOINT}/search/?q=certstream-suspicious&size=#{size}"
      res = JSON.parse(get(url))
      res["results"].map { |result| result.dig("task", "url") }
    end

    def openphish_feed
      res = get("#{OPENPHISH_ENDPOINT}/feed.txt")
      res.lines.map(&:chomp)
    end

    def breakdown(url)
      begin
        uri = URI.parse(url)
      rescue URI::InvalidURIError => _
        return []
      end
      base = "#{uri.scheme}://#{uri.hostname}"
      [base]
      # TODO: Should add a option for burute force directory
      # segments = uri.path.split("/")
      # if segments.length.zero?
      #   [base]
      # else
      #   (0...segments.length).map { |idx| "#{base}#{segments[0..idx].join('/')}" }
      # end
    end

    def suspicious_urls
      urls = urlscan_feed + openphish_feed
      urls.map { |url| breakdown(url) }.flatten.uniq.sort
    end

    def execute
      pool = Thread.pool(threads)
      websites = []

      suspicious_urls.each do |url|
        pool.process do
          website = Website.new(url)
          puts "#{website.url}: it doesn't contain a phishing kit." if verbose && !website.has_kit?
          websites << website
        end
      end
      pool.shutdown

      websites
    end

    def self.execute(size: 100, verbose: false)
      new(size: size, verbose: verbose).execute
    end

    private

    def get(url)
      res = HTTP.get(url)
      raise HTTPResponseError if res.code != 200

      res.body.to_s
    end
  end
end
