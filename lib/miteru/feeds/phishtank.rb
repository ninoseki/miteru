# frozen_string_literal: true

require "csv"

module Miteru
  class Feeds
    class PhishTank < Feed
      ENDPOINT = "http://data.phishtank.com"

      def urls
        res = get("#{ENDPOINT}/data/online-valid.csv")
        table = CSV.parse(res, headers: true)
        table.map { |row| row["url"] }
      rescue HTTPResponseError => e
        puts "Failed to load PhishTank feed (#{e})"
        []
      end
    end
  end
end
