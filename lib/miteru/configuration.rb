# frozen_string_literal: true

require "parallel"

module Miteru
  class Configuration
    # @return [Boolean]
    attr_accessor :auto_download

    # @return [Boolean]
    attr_accessor :ayashige

    # @return [Boolean]
    attr_accessor :directory_traveling

    # @return [String]
    attr_accessor :download_to

    # @return [Boolean]
    attr_accessor :post_to_slack

    # @return [Integer]
    attr_accessor :size

    # @return [Integer]
    attr_accessor :threads

    # @return [Boolean]
    attr_accessor :verbose

    # @return [String]
    attr_accessor :database

    # @return [String, nil]
    attr_accessor :slack_webhook_url

    # @return [String]
    attr_accessor :slack_channel

    # @return [String]
    attr_accessor :urlscan_api_key

    # @return [String]
    attr_accessor :urlscan_submit_visibility

    # @return [Array<String>]
    attr_reader :valid_extensions

    # @return [Array<String>]
    attr_reader :valid_mime_types

    def initialize
      @auto_download = false
      @ayashige = false
      @directory_traveling = false
      @download_to = "/tmp"
      @post_to_slack = false
      @size = 100
      @threads = Parallel.processor_count
      @verbose = false
      @database = ENV.fetch("MITERU_DATABASE", "miteru.db")

      @slack_webhook_url = ENV.fetch("SLACK_WEBHOOK_URL", nil)
      @slack_channel = ENV.fetch("SLACK_CHANNEL", "#general")

      @urlscan_api_key = ENV.fetch("URLSCAN_API_KEY", nil)
      @urlscan_submit_visibility = ENV.fetch("URLSCAN_SUBMIT_VISIBILITY", "public")

      @valid_extensions = [".zip", ".rar", ".7z", ".tar", ".gz"].freeze
      @valid_mime_types = ["application/zip", "application/vnd.rar", "application/x-7z-compressed", "application/x-tar", "application/gzip"]
    end

    def auto_download?
      @auto_download
    end

    def ayashige?
      @ayashige
    end

    def directory_traveling?
      @directory_traveling
    end

    def post_to_slack?
      @post_to_slack
    end

    def verbose?
      @verbose
    end

    def slack_webhook_url?
      !@slack_webhook_url.nil?
    end

    def urlscan_api_key?
      !@urlscan_api_key.nil?
    end
  end

  class << self
    # @return [Miteru::Configuration] Miteru's current configuration
    def configuration
      @configuration ||= Configuration.new
    end

    # Set Miteru's configuration
    # @param config [Miteru::Configuration]
    attr_writer :configuration

    # Modify Miteru's current configuration
    # @yieldparam [Miteru::Configuration] config current Miteru config
    def configure
      yield configuration
    end
  end
end
