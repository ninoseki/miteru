# frozen_string_literal: true

require "slack-notifier"

module Miteru
  module Notifiers
    class SlackAttachment
      attr_reader :url

      def initialize(url)
        @url = url
      end

      def to_a
        [
          {
            text: defanged_url,
            fallback: "VT & urlscan.io links",
            actions:
          }
        ]
      end

      private

      def actions
        [vt_link, urlscan_link].compact
      end

      def vt_link
        return nil unless _vt_link

        {
          type: "button",
          text: "Lookup on VirusTotal",
          url: _vt_link
        }
      end

      def urlscan_link
        return nil unless _urlscan_link

        {
          type: "button",
          text: "Lookup on urlscan.io",
          url: _urlscan_link
        }
      end

      def defanged_url
        @defanged_url ||= url.to_s.gsub(".", "[.]")
      end

      def domain
        @domain ||= [].tap do |out|
          out << URI(url).hostname
        rescue URI::Error => _e
          out << nil
        end.first
      end

      def _urlscan_link
        return nil unless domain

        "https://urlscan.io/domain/#{domain}"
      end

      def _vt_link
        return nil unless domain

        "https://www.virustotal.com/#/domain/#{domain}"
      end
    end

    class Slack < Base
      #
      # Notifiy to Slack
      #
      # @param [Miteru::Website] website
      #
      def call(website)
        return unless callable?

        attachment = SlackAttachment.new(website.url)
        kits = website.kits.select(&:downloaded?)
        notifier.post(text: website.message.capitalize, attachments: attachment.to_a) if kits.any?
      end

      def callable?
        !slack_webhook_url.nil?
      end

      private

      def webhook_url
        Miteru.config.slack_webhook_url
      end

      def channel
        Miteru.config.slack_channel
      end

      def notifier
        ::Slack::Notifier.new(webhook_url, channel:)
      end
    end
  end
end
