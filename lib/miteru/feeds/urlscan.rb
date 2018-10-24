# frozen_string_literal: true

require "json"

module Miteru
  class Feeds
    class UrlScan < Feed
      ENDPOINT = "https://urlscan.io/api/v1"

      attr_reader :size
      def initialize(size = 100)
        @size = size
        raise ArgumentError, "size must be less than 100,000" if size > 100_000
      end

      def urls
        url = "#{ENDPOINT}/search/?q=certstream-suspicious&size=#{size}"
        res = JSON.parse(get(url))
        res["results"].map { |result| result.dig("task", "url") }
      rescue HTTPResponseError => e
        puts "Failed to load urlscan.io feed (#{e})"
        []
      end
    end
  end
end
