# frozen_string_literal: true

require "down"
require "uri"

module Miteru
  class Downloader
    attr_reader :url, :base_dir
    def initialize(url, base_dir = "/tmp")
      @url = url
      @base_dir = base_dir
    end

    def filename
      uri = URI.parse(url)
      File.basename(uri.path)
    end

    def destination
      @destination ||= "#{base_dir}/#{filename}"
    end

    def download
      Down.download(url, destination: destination)
    end

    def self.download(url, base_dir = "/tmp")
      new(url, base_dir).download
    end
  end
end
