# frozen_string_literal: true

module Miteru
  module Notifiers
    class UrlScan < Base
      #
      # @param [Miteru::Website] website
      #
      def call(website)
        return unless callable?

        website.kits.each { |kit| submit(kit.url, source: website.source) }
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
        Miteru.config.api_timeout
      end

      def tags
        %w[miteru phishkit]
      end

      def visibility
        Miteru.config.urlscan_submit_visibility
      end

      #
      # @param [String] url
      # @param [String] source
      #
      def submit(url, source:)
        http.post("https://urlscan.io/api/v1/scan/", json: {tags: tags + ["source:#{source}"], visibility:, url:})
      end
    end
  end
end
