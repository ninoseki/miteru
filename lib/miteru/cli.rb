# frozen_string_literal: true

require "http"
require "thor"

module Miteru
  class CLI < Thor
    method_option :post_to_slack, type: :boolean, default: false
    desc "execute", "Execute the crawler"
    def execute
      results = Crawler.execute
      results.each do |result|
        message = "#{result} might contain a phishing kit."
        puts message
        post_to_slack(message) if options[:post_to_slack] && valid_slack_setting?
      end
    end

    no_commands do
      def valid_slack_setting?
        ENV["SLACK_WEBHOOK_URL"] != nil
      end

      def post_to_slack(message)
        webhook_url = ENV["SLACK_WEBHOOK_URL"]
        raise ArgumentError, "Please set the Slack webhook URL via SLACK_WEBHOOK_URL env" unless webhook_url

        channel = ENV["SLACK_CHANNEL"] || "#general"

        payload = { text: message, channel: channel }
        HTTP.post(webhook_url, json: payload)
      end
    end
  end
end
