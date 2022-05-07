# frozen_string_literal: true

require "down/http"
require "http"
require "uri"

module Miteru
  class HTTPClient
    DEFAULT_UA = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36"
    URLSCAN_UA = "miteru/#{Miteru::VERSION}"

    attr_reader :ssl_context

    def initialize
      ctx = OpenSSL::SSL::SSLContext.new
      ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE
      @ssl_context = ctx
    end

    def download(url, destination)
      down = Down::Http.new(**default_options) { |client| client.headers(**default_headers) }
      down.download(url, destination: destination)
      destination
    end

    def head(url, options = {})
      options = options.merge default_options

      HTTP.follow
        .timeout(3)
        .headers(urlscan_url?(url) ? urlscan_headers : default_headers)
        .head(url, options)
    end

    def get(url, options = {})
      options = options.merge default_options

      HTTP.follow
        .timeout(write: 2, connect: 5, read: 10)
        .headers(urlscan_url?(url) ? urlscan_headers : default_headers)
        .get(url, options)
    end

    def post(url, options = {})
      HTTP.post url, options
    end

    class << self
      def download(url, base_dir = "/tmp")
        new.download(url, base_dir)
      end

      def get(url, options = {})
        new.get url, options
      end

      def post(url, options = {})
        new.post url, options
      end

      def head(url, options = {})
        new.head url, options
      end
    end

    private

    def default_headers
      { user_agent: DEFAULT_UA }
    end

    def default_options
      { ssl_context: ssl_context }
    end

    def urlscan_headers
      { user_agent: URLSCAN_UA }
    end

    def urlscan_url?(url)
      uri = URI(url)
      uri.hostname == "urlscan.io"
    end
  end
end
