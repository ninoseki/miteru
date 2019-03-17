# frozen_string_literal: true

require "uri"

module Miteru
  class Attachement
    attr_reader :url
    def initialize(url)
      @url = url
    end

    def to_h
      {
        fallback: "urlscan.io link",
        title: title,
        title_link: title_link,
        footer: "urlscan.io",
        footer_icon: "http://www.google.com/s2/favicons?domain=urlscan.io"
      }
    end

    private

    def title_link
      domain ? "https://urlscan.io/domain/#{domain}" : "https://urlscan.io"
    end

    def title
      domain || "N/A"
    end

    def domain
      @domain ||=
        [].tap do |out|
          out << URI(url).hostname
        rescue URI::Error => _
          out << nil
        end.first
    end
  end
end
