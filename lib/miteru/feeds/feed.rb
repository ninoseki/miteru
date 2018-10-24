# frozen_string_literal: true

module Miteru
  class Feeds
    class Feed
      def urls
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      private

      def get(url)
        res = HTTPClient.get(url)
        raise HTTPResponseError if res.code != 200

        res.body.to_s
      end
    end
  end
end
