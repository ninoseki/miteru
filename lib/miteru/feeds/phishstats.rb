# frozen_string_literal: true

require "json"
require "uri"

module Miteru
  class Feeds
    class PhishStats < Feed
      URL = "https://phishstats.info:2096/api/phishing?_sort=-id&size=100"

      def urls
        json = JSON.parse(get(URL))
        json.map do |entry|
          entry["url"]
        end
      rescue HTTPResponseError, HTTP::Error, JSON::ParserError => e
        Miteru.logger.error "Failed to load PhishStats feed (#{e})"
        []
      end

      private

      def url_for(path)
        URI(URL + path)
      end
    end
  end
end
