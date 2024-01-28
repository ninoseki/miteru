# frozen_string_literal: true

module Miteru
  class Feeds
    class PhishingDatabase < Base
      def initialize(base_url = "https://raw.githubusercontent.com")
        super(base_url)
      end

      def urls
        text.lines.map(&:chomp)
      end

      private

      def text
        get("/mitchellkrogza/Phishing.Database/master/phishing-links-ACTIVE-NOW.txt").body.to_s
      end
    end
  end
end
