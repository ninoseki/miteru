# frozen_string_literal: true

require "json"
require "uri"

module Miteru
  class Feeds
    class Ayashige < Feed
      HOST = "ayashige.herokuapp.com"
      URL = "https://#{HOST}"

      def urls
        url = url_for("/feed")
        res = JSON.parse(get(url))

        domains = res.map { |item| item["domain"]}
        domains.map do |domain|
          [
            "https://#{domain}",
            "http://#{domain}"
          ]
        end.flatten
      rescue HTTPResponseError => e
        puts "Failed to load ayashige feed (#{e})"
        []
      end

      private

      def url_for(path)
        URI(URL + path)
      end
    end
  end
end
