# frozen_string_literal: true

require "uri"

module Miteru
  class Attachement
    attr_reader :url
    def initialize(url)
      @url = url
    end

    def to_a
      [
        {
          text: defanged_url,
          fallback: "VT & urlscan.io links",
          actions: actions
        }
      ]
    end

    private

    def actions
      [vt_link, urlscan_link].compact
    end

    def vt_link
      return nil unless _vt_link

      {
        type: "button",
        text: "Lookup on VirusTotal",
        url: _vt_link
      }
    end

    def urlscan_link
      return nil unless _urlscan_link

      {
        type: "button",
        text: "Lookup on urlscan.io",
        url: _urlscan_link
      }
    end

    def defanged_url
      @defanged_url ||= url.to_s.gsub /\./, "[.]"
    end

    def domain
      @domain ||=
        [].tap do |out|
          out << URI(url).hostname
        rescue URI::Error => _e
          out << nil
        end.first
    end

    def _urlscan_link
      return nil unless domain

      "https://urlscan.io/domain/#{domain}"
    end

    def _vt_link
      return nil unless domain

      "https://www.virustotal.com/#/domain/#{domain}"
    end
  end
end
