# frozen_string_literal: true

require "colorize"
require "slack-notifier"

module Miteru
  module Notifiers
    class Slack < Base
      #
      # Notifiy to Slack
      #
      # @param [Miteru::Website website
      #
      def notify(website)
        attachement = Attachement.new(website.url)
        kits = website.kits.select(&:downloaded?)

        notifier.post(text: website.message.capitalize, attachments: attachement.to_a) if notifiable? && kits.any?

        message = kits.any? ? website.message.colorize(:light_red) : website.message
        Miteru.logger.info "#{website.url}: #{message}"
      end

      def notifiable?
        Miteru.configuration.slack_webhook_url? && Miteru.configuration.post_to_slack?
      end

      def notifier
        Slack::Notifier.new(Miteru.configuration.slack_webhook_url, channel: Miteru.configuration.slack_channel)
      end
    end
  end
end
