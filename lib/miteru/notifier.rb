# frozen_string_literal: true

require "colorize"
require "slack/incoming/webhooks"

module Miteru
  class Notifier
    def initialize(post_to_slack = false)
      @post_to_slack = post_to_slack
    end

    def notify(url:, kits:, message:)
      attachement = Attachement.new(url)

      if post_to_slack? && !kits.empty?
        slack = Slack::Incoming::Webhooks.new(slack_webhook_url, channel: slack_channel)
        slack.post(
          url,
          attachments: [
            { text: message },
            attachement.to_h
          ]
        )
      end

      message = message.colorize(:light_red) unless kits.empty?
      puts "#{url}: #{message}"
    end

    def post_to_slack?
      @post_to_slack && slack_webhook_url?
    end

    def slack_webhook_url
      ENV.fetch "SLACK_WEBHOOK_URL"
    end

    def slack_channel
      ENV.fetch "SLACK_CHANNEL", "#general"
    end

    def slack_webhook_url?
      ENV.key? "SLACK_WEBHOOK_URL"
    end
  end
end
