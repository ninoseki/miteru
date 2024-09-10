# frozen_string_literal: true

module Miteru
  class Feeds
    class UrlScanPro < Base
      #
      # @param [String] base_url
      #
      def initialize(base_url = "https://urlscan.io")
        super

        @headers = {"api-key": api_key}
      end

      def urls
        (json["results"] || []).map { |result| result["page_url"] }
      end

      private

      def api_key
        Miteru.config.urlscan_api_key
      end

      def q
        Miteru.config.urlscan_date_condition
      end

      def format
        "json"
      end

      def json
        get_json("/api/v1/pro/phishfeed", params: {q:, format:})
      end
    end
  end
end
