# frozen_string_literal: true

module Miteru
  class Feeds
    class Feed
      include Mixins::URL

      def source
        @source ||= self.class.to_s.split("::").last
      end

      #
      # Return URLs
      #
      # @return [Array<String>] URLs
      #
      def urls
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      #
      # Return entries
      #
      # @return [Array<Miteru::Entry>]
      #
      def entries
        breakdowend_urls.map do |url|
          Entry.new(url, source)
        end
      end

      #
      # Return breakdowned URLs
      #
      # @return [Array<String>] Breakdowned URLs
      #
      def breakdowend_urls
        urls.select { |url| url.start_with?("http://", "https://") }.map do |url|
          breakdown(url, Miteru.configuration.directory_traveling?)
        end.flatten.uniq
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
