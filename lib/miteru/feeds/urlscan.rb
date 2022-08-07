# frozen_string_literal: true

require "urlscan"

module Miteru
  class Feeds
    class UrlScan < Feed
      attr_reader :size

      def initialize(size = 100)
        @size = size
        raise ArgumentError, "size must be less than 10,000" if size > 10_000
      end

      def api
        @api ||= ::UrlScan::API.new(Miteru.configuration.urlscan_api_key)
      end

      def urls
        urls_from_community_feed
      rescue ::UrlScan::ResponseError => e
        puts "Failed to load urlscan.io feed (#{e})"
        []
      end

      private

      def urls_from_community_feed
        res = api.search("task.method:automatic", size: size)

        results = res["results"] || []
        results.map { |result| result.dig("task", "url") }
      end
    end
  end
end
