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
        iterate.flat_map do |res|
          (res["results"] || []).map { |result| result.dig("page", "url") }
        end.uniq
      end

      private

      def api_key
        Miteru.config.urlscan_api_key
      end

      def q
        ["verdicts.urlscan.malicious:true", Miteru.config.urlscan_date_condition].join(" AND ")
      end

      def size
        10
      end

      def iterate
        search_after = nil

        Enumerator.new do |y|
          loop do
            got = get_json("/api/v1/search/", params: {size:, search_after:, q:}.compact)

            y.yield got

            results = got["results"] || []
            break if results.empty? || results.size < size

            search_after = results.last["sort"].join(",")
          end
        end
      end
    end
  end
end
