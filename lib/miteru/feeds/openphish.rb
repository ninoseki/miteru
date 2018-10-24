# frozen_string_literal: true

require "json"

module Miteru
  class Feeds
    class OpenPhish < Feed
      ENDPOINT = "https://openphish.com"

      def urls
        res = get("#{ENDPOINT}/feed.txt")
        res.lines.map(&:chomp)
      rescue HTTPResponseError => e
        puts "Failed to load OpenPhish feed (#{e})"
        []
      end
    end
  end
end
