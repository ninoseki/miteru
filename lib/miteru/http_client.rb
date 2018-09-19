# frozen_string_literal: true

require "http"
require "down/http"
require "securerandom"

module Miteru
  class HTTPClient
    DEFAULT_UA = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36"
    attr_reader :ssl_context
    def initialize
      ctx = OpenSSL::SSL::SSLContext.new
      ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE
      @ssl_context = ctx
    end

    def download(url, base_dir)
      destination = download_to(base_dir, save_filename)
      down = Down::Http.new(default_options) { |client| client.headers(default_headers) }
      down.download(url, destination: destination)
      destination
    end

    def self.download(url, base_dir = "/tmp")
      new.download(url, base_dir)
    end

    def get(url)
      HTTP.headers(default_headers).get(url, default_options)
    end

    def self.get(url)
      new.get url
    end

    private

    def default_headers
      { user_agent: DEFAULT_UA }
    end

    def default_options
      { ssl_context: ssl_context }
    end

    def save_filename
      "#{SecureRandom.alphanumeric}.zip"
    end

    def download_to(base_dir, save_filename)
      "#{base_dir}/#{save_filename}"
    end
  end
end
