# frozen_string_literal: true

require "http"
require "json"
require "thread/pool"
require "uri"

module Miteru
  class Crawler
    attr_reader :directory_traveling
    attr_reader :size
    attr_reader :threads
    attr_reader :verbose

    URLSCAN_ENDPOINT = "https://urlscan.io/api/v1"
    OPENPHISH_ENDPOINT = "https://openphish.com"

    def initialize(directory_traveling: false, size: 100, threads: 10, verbose: false)
      @directory_traveling = directory_traveling
      @size = size
      @threads = threads
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
      return [base] unless directory_traveling

      segments = uri.path.split("/")
      return [base] if segments.length.zero?

      urls = (0...segments.length).map { |idx| "#{base}#{segments[0..idx].join('/')}" }
      urls.reject do |breakdowned_url|
        # Reject a url which ends with specific extension names
        %w(.htm .html .php .asp .aspx).any? { |ext| breakdowned_url.end_with? ext }
      end
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
          unless website.has_kit?
            puts "#{website.url}: it doesn't contain a phishing kit." if verbose
            website.unbuild
          end
          websites << website
        end
      end
      pool.shutdown

      websites
    end

    def self.execute(directory_traveling: false, size: 100, threads: 10, verbose: false)
      new(directory_traveling: directory_traveling, size: size, threads: threads, verbose: verbose).execute
    end

    private

    def get(url)
      res = HTTP.get(url)
      raise HTTPResponseError if res.code != 200

      res.body.to_s
    end
  end
end
