# frozen_string_literal: true

require "colorize"
require "slack-notifier"

module Miteru
  class Notifier
    def notify(url:, kits:, message:)
      attachement = Attachement.new(url)
      kits = kits.select(&:filesize)

      if notifiable? && kits.any?
        notifier = Slack::Notifier.new(Miteru.configuration.slack_webhook_url, channel: Miteru.configuration.slack_channel)
        notifier.post(text: message.capitalize, attachments: attachement.to_a)
      end

      message = message.colorize(:light_red) if kits.any?
      puts "#{url}: #{message}"
    end

    def notifiable?
      Miteru.configuration.slack_webhook_url? && Miteru.configuration.post_to_slack?
    end
  end
end
