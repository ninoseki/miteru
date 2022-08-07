# frozen_string_literal: true

require "urlscan"

module Miteru
  class Feeds
    class UrlScanPro < Feed
      def api
        @api ||= ::UrlScan::API.new(Miteru.configuration.urlscan_api_key)
      end

      def urls
        urls_from_pro_feed
      rescue ::UrlScan::ResponseError => e
        Miteru.logger.error "Failed to load urlscan.io pro feed (#{e})"
        []
      end

      private

      def api_key?
        Miteru.configuration.urlscan_api_key?
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
