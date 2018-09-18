# frozen_string_literal: true

require "thread/pool"
require "http"

module Miteru
  class Crawler
    attr_reader :threads
    def initialize
      @threads = 10
    end

    def suspicous_urls
      url = "https://urlscan.io/api/v1/search/?q=certstream-suspicious"
      res = JSON.parse(get(url))
      res["results"].map { |result| result.dig("task", "url") }
    end

    def execute(verbose = false)
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

    def self.execute(verbose = false)
      new.execute(verbose)
    end

    private

    def get(url)
      res = HTTP.get(url)
      raise HTTPResponseError if res.code != 200

      res.body.to_s
    end
  end
end
