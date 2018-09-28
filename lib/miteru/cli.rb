# frozen_string_literal: true

require "colorize"
require "digest"
require "fileutils"
require "http"
require "thor"

module Miteru
  class CLI < Thor
    method_option :auto_download, type: :boolean, default: false, desc: "Enable or disable auto-download of *.zip file(s)"
    method_option :directory_traveling, type: :boolean, default: false, desc: "Enable or disable directory traveling"
    method_option :download_to, type: :string, default: "/tmp", desc: "Directory to download file(s)"
    method_option :post_to_slack, type: :boolean, default: false, desc: "Post a message to Slack if it detects a phishing kit"
    method_option :size, type: :numeric, default: 100, desc: "Number of urlscan.io's results. (Max: 100,000)"
    method_option :threads, type: :numeric, default: 10, desc: "Number of threads to use"
    method_option :verbose, type: :boolean, default: true
    desc "execute", "Execute the crawler"
    def execute
      websites = Crawler.execute(
        directory_traveling: options[:directory_traveling],
        size: options[:size],
        threads: options[:threads],
        verbose: options[:verbose]
      )
      websites.each do |website|
        next unless website.has_kit?

        message = "#{website.url}: it might contain phishing kit(s) (#{website.zip_files.join(', ')})."
        puts message.colorize(:light_red)
        post_to_slack(message) if options[:post_to_slack] && valid_slack_setting?
        download_zip_files(website.url, website.zip_files, options[:download_to]) if options[:auto_download]
      end
    end

    no_commands do
      def download_zip_files(url, zip_files, base_dir)
        zip_files.each do |path|
          target_url = "#{url}/#{path}"
          begin
            download_file_path = HTTPClient.download(target_url, base_dir)
            if duplicated?(download_file_path, base_dir)
              puts "Do not download #{target_url} because there is a same hash file in the directory (SHA256: #{sha256(download_file_path)})."
              FileUtils.rm download_file_path
            else
              puts "Download #{target_url} as #{download_file_path}"
            end
          rescue Down::Error => e
            puts "Failed to download: #{target_url} (#{e})"
          end
        end
      end

      def sha256(path)
        digest = Digest::SHA256.file(path)
        digest.hexdigest
      end

      def duplicated?(file_path, base_dir)
        base = sha256(file_path)
        sha256s = Dir.glob("#{base_dir}/*.zip").map { |path| sha256(path) }
        sha256s.select { |sha256| sha256 == base }.length > 1
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
