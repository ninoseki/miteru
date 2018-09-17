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

    def execute
      pool = Thread.pool(threads)
      results = []

      suspicous_urls.each do |url|
        pool.process do
          doc = Website.new(url)
          results << url if doc.has_kit?
        rescue HTTPResponseError => _
          next
        end
      end
      pool.shutdown

      results
    end

    def self.execute
      new.execute
    end

    private

    def get(url)
      res = HTTP.get(url)
      raise HTTPResponseError if res.code != 200

      res.body.to_s
    end
  end
end
