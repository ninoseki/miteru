# frozen_string_literal: true

require "urlscan"

module Miteru
  class Feeds
    class UrlScanPro < Feed
      def api
        @api ||= ::UrlScan::API.new
      end

      def urls
        urls_from_pro_feed
      rescue ::UrlScan::ResponseError => e
        puts "Failed to load urlscan.io pro feed (#{e})"
        []
      end

      private

      def api_key?
        ENV.key? "URLSCAN_API_KEY"
      end

      def urls_from_pro_feed
        return [] unless api_key?

        res = api.pro.phishfeed
        results = res["results"] || []
        results.map { |result| result["page_url"] }
      rescue ArgumentError => _e
        []
      end
    end
  end
end
