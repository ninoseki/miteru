# frozen_string_literal: true

require "json"
require "uri"

module Miteru
  class Feeds
    class UrlScan < Feed
      HOST = "urlscan.io"
      VERSION = 1
      URL = "https://#{HOST}/api/v#{VERSION}"

      attr_reader :size
      def initialize(size = 100)
        @size = size
        raise ArgumentError, "size must be less than 10,000" if size > 10_000
      end

      def urls
        url = url_for("/search/")
        url.query = URI.encode_www_form(
          q: "task.method:automatic",
          size: size
        )

        res = JSON.parse(get(url))
        res["results"].map { |result| result.dig("task", "url") }
      rescue HTTPResponseError, HTTP::Error, JSON::ParserError => e
        puts "Failed to load urlscan.io feed (#{e})"
        []
      end

      private

      def url_for(path)
        URI(URL + path)
      end
    end
  end
end
