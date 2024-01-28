# frozen_string_literal: true

module Miteru
  module Notifiers
    class UrlScan < Base
      #
      # @param [Miteru::Website] website
      #
      def call(website)
        return unless callable?

        kits = website.kits.select(&:downloaded?)
        return unless kits.any?

        kits.each { |kit| submit(kit.url) }
      end

      def callable?
        !Miteru.config.urlscan_api_key.nil?
      end

      private

      #
      # @return [::HTTP::Client]
      #
      def http
        @http ||= HTTP::Factory.build(headers:, timeout:)
      end

      def headers
        {"api-key": Miteru.config.urlscan_api_key}
      end

      def timeout
        Miteru.config.timeout
      end

      def tags
        %w[miteru phishkit]
      end

      def visibility
        Miteru.config.urlscan_submit_visibility
      end

      def submit(url)
        http.post("/api/v1/scan/", json: {tags:, visibility:, url:})
      end
    end
  end
end
