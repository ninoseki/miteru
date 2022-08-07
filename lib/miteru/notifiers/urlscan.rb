# frozen_string_literal: true

require "urlscan"

module Miteru
  module Notifiers
    class UrlScan < Base
      #
      # Notifiy to urlscan.io
      #
      # @param [Miteru::Website website
      #
      def notify(website)
        kits = website.kits.select(&:downloaded?)
        return unless notifiable? && kits.any?

        kits.each { |kit| submit(kit.url) }
      end

      def notifiable?
        Miteru.configuration.urlscan_api_key?
      end

      private

      def api
        @api ||= ::UrlScan::API.new(Miteru.configuration.urlscan_api_key)
      end

      def submit(url)
        api.submit(url, tags: ["miteru", "phishkit"], visibility: Miteru.configuration.urlscan_submit_visibility)
      rescue StandardError
        # do nothing
      end
    end
  end
end
