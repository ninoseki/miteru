# frozen_string_literal: true

require "thor"

module Miteru
  class CLI < Thor
    method_option :auto_download, type: :boolean, default: false, desc: "Enable or disable auto-download of phishing kits"
    method_option :ayashige, type: :boolean, default: false, desc: "Enable or disable Ayashige(ninoseki/ayashige) feed"
    method_option :directory_traveling, type: :boolean, default: false, desc: "Enable or disable directory traveling"
    method_option :download_to, type: :string, default: "/tmp", desc: "Directory to download phishing kits"
    method_option :post_to_slack, type: :boolean, default: false, desc: "Enable or disable Slack notification"
    method_option :size, type: :numeric, default: 100, desc: "Number of urlscan.io's results to fetch. (Max: 10,000)"
    method_option :threads, type: :numeric, desc: "Number of threads to use"
    method_option :verbose, type: :boolean, default: true
    desc "execute", "Execute the crawler"
    def execute
      Miteru.configure do |config|
        config.auto_download = options["auto_download"]
        config.ayashige = options["ayashige"]
        config.directory_traveling = options["directory_traveling"]
        config.download_to = options["download_to"]
        config.post_to_slack = options["post_to_slack"]
        config.size = options["size"]
        config.verbose = options["verbose"]

        threads = options["threads"]
        config.threads = threads if threads
      end

      Crawler.execute
    end

    default_command :execute

    class << self
      def exit_on_failure?
        true
      end
    end
  end
end
