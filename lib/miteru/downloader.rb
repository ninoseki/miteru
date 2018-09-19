# frozen_string_literal: true

require "down"
require "securerandom"

module Miteru
  class Downloader
    attr_reader :url, :base_dir
    def initialize(url, base_dir = "/tmp")
      @url = url
      @base_dir = base_dir
    end

    def save_filename
      "#{SecureRandom.alphanumeric}.zip"
    end

    def destination
      @destination ||= "#{base_dir}/#{save_filename}"
    end

    def download
      Down.download(url, destination: destination)
      destination
    end

    def self.download(url, base_dir = "/tmp")
      new(url, base_dir).download
    end
  end
end
