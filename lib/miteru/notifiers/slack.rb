# frozen_string_literal: true

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

        if notifiable? && kits.any?
          notifier = Slack::Notifier.new(Miteru.configuration.slack_webhook_url, channel: Miteru.configuration.slack_channel)
          notifier.post(text: website.message.capitalize, attachments: attachement.to_a)
        end

        message = kits.any? ? website.message.colorize(:light_red) : website.message
        puts "#{website.url}: #{message}"
      end

      def notifiable?
        Miteru.configuration.slack_webhook_url? && Miteru.configuration.post_to_slack?
      end
    end
  end
end
