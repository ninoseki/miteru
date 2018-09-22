# frozen_string_literal: true

require "thread/pool"
require "http"

module Miteru
  class Crawler
    attr_reader :threads
    attr_reader :size
    attr_reader :verbose

    def initialize(size: 100, verbose: false)
      @threads = 10
      @size = size
      @verbose = verbose
      raise ArgumentError, "size must be less than 100,000" if size > 100_000
    end

    def suspicous_urls
      url = "https://urlscan.io/api/v1/search/?q=certstream-suspicious&size=#{size}"
      res = JSON.parse(get(url))
      res["results"].map { |result| result.dig("task", "url") }
    end

    def execute
      pool = Thread.pool(threads)
      websites = []

      suspicous_urls.each do |url|
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
