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

    def has_kit?(url)
      begin
        res = get(url)
      rescue HTTPResponseError => _
        false
      end

      rules = ["Index of", ".zip"]
      rules.all? { |rule| res.include? rule }
    end

    def execute
      pool = Thread.pool(threads)
      results = []

      suspicous_urls.each do |url|
        pool.process { results << url if has_kit?(url) }
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
