# frozen_string_literal: true

require "colorize"
require "http"
require "thor"

module Miteru
  class CLI < Thor
    method_option :auto_download, type: :boolean, default: false
    method_option :download_to, type: :string, default: "/tmp"
    method_option :post_to_slack, type: :boolean, default: false
    method_option :verbose, type: :boolean, default: true
    desc "execute", "Execute the crawler"
    def execute
      websites = Crawler.execute(options[:verbose])
      websites.each do |website|
        next unless website.has_kit?

        puts "#{website.url}: it might contain a phishing kit (#{website.zip_files.join(',')}).".colorize(:light_red)
        post_to_slack(message) if options[:post_to_slack] && valid_slack_setting?
        download_zip_files(website.url, website.zip_files, options[:download_to]) if options[:auto_download]
      end
    end

    no_commands do
      def download_zip_files(url, zip_files, base_dir)
        zip_files.each do |path|
          target_url = "#{url}/#{path}"
          begin
            destination = Downloader.download(target_url, base_dir)
            puts "Download #{target_url} as #{destination}"
          rescue Down::Error => e
            puts "Failed to download: #{target_url} (#{e})"
          end
        end
      end

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
