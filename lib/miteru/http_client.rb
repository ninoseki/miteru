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
      destination = download_path(base_dir, filename_to_save(url))
      down = Down::Http.new(default_options) { |client| client.headers(default_headers) }
      down.download(url, destination: destination)
      destination
    end

    def self.download(url, base_dir = "/tmp")
      new.download(url, base_dir)
    end

    def get(url, options = {})
      options = options.merge default_options
      HTTP.follow.timeout(write: 2, connect: 5, read: 10).headers(default_headers).get(url, options)
    end

    def self.get(url, options = {})
      new.get url, options
    end

    def post(url, options = {})
      HTTP.post url, options
    end

    def self.post(url, options = {})
      new.post url, options
    end

    private

    def default_headers
      { user_agent: DEFAULT_UA }
    end

    def default_options
      { ssl_context: ssl_context }
    end

    def filename_to_save(url)
      filename = url.split("/").last
      extname = File.extname(filename)
      "#{SecureRandom.alphanumeric}.#{extname}"
    end

    def download_path(base_dir, filename)
      "#{base_dir}/#{filename}"
    end
  end
end
