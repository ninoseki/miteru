# frozen_string_literal: true

require "thor"

module Miteru
  class CLI < Thor
    method_option :auto_download, type: :boolean, default: false, desc: "Enable or disable auto-download of phishing kits"
    method_option :directory_traveling, type: :boolean, default: false, desc: "Enable or disable directory traveling"
    method_option :download_to, type: :string, default: "/tmp", desc: "Directory to download file(s)"
    method_option :post_to_slack, type: :boolean, default: false, desc: "Post a message to Slack if it detects a phishing kit"
    method_option :size, type: :numeric, default: 100, desc: "Number of urlscan.io's results. (Max: 10,000)"
    method_option :threads, type: :numeric, desc: "Number of threads to use"
    method_option :verbose, type: :boolean, default: true
    desc "execute", "Execute the crawler"
    def execute
      Crawler.execute options.map { |k, v| [k.to_sym, v] }.to_h
    end
  end
end
