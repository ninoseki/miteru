# frozen_string_literal: true

module Miteru
  class Feeds
    class UrlScan < Base
      #
      # @param [String] base_url
      #
      def initialize(base_url = "https://urlscan.io")
        super

        @headers = {"api-key": api_key}
      end

      def urls
        search_with_pagination.flat_map do |json|
          (json["results"] || []).map { |result| result.dig("task", "url") }
        end.uniq
      end

      private

      def size
        10_000
      end

      # @return [<Type>] <description>
      #
      def api_key
        Miteru.config.urlscan_api_key
      end

      def q
        "#{base_condition} AND #{date_condition}"
      end

      #
      # @param [String, nil] search_after
      #
      # @return [Hash]
      #
      def search(search_after: nil)
        get_json("/api/v1/search/", params: {q:, size:, search_after:}.compact)
      end

      def search_with_pagination
        search_after = nil

        Enumerator.new do |y|
          loop do
            res = search(search_after:)

            y.yield res

            has_more = res["has_more"]
            break unless has_more

            search_after = res["results"].last["sort"].join(",")
          end
        end
      end

      def base_condition
        Miteru.config.urlscan_base_condition
      end

      def date_condition
        Miteru.config.urlscan_date_condition
      end
    end
  end
end
