# frozen_string_literal: true

module Miteru
  class Feeds
    class TweetFeed < Base
      def initialize(base_url = "https://api.tweetfeed.live")
        super(base_url)
      end

      def urls
        data = get_json("/v1/today/url")
        data.filter_map { |item| item["value"] }
      end
    end
  end
end
