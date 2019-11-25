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

    def initialize
      @auto_download = false
      @ayashige = false
      @directory_traveling = false
      @download_to = "/tmp"
      @post_to_slack = false
      @size = 100
      @threads = Parallel.processor_count
      @verbaose = false
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
