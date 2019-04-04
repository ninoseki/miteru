# frozen_string_literal: true

require "oga"

module Miteru
  class Website
    attr_reader :url
    def initialize(url)
      @url = url
    end

    def title
      doc&.at_css("title")&.text
    end

    def kits
      @kits ||= links.map do |link|
        kit = Kit.new(base_url: url, link: link.to_s)
        kit.valid? ? kit : nil
      end.compact
    end

    def ok?
      response.code == 200
    end

    def index?
      title == "Index of /"
    end

    def kits?
      !kits.empty?
    end

    def has_kits?
      ok? && index? && kits?
    rescue OpenSSL::SSL::SSLError, HTTP::Error, Addressable::URI::InvalidURIError => _
      false
    end

    def message
      kit_names = kits.map(&:basename).join(", ")
      kits? ? "it might contain phishing kit(s): (#{kit_names})." : "it doesn't contain a phishing kit."
    end

    private

    def response
      @response ||= get
    end

    def get
      HTTPClient.get url
    end

    def doc
      @doc ||= parse_html(response.body.to_s)
    end

    def parse_html(html)
      Oga.parse_html(html)
    rescue ArgumentError, Encoding::CompatibilityError, LL::ParserError => _
      nil
    end

    def links
      if doc
        doc.css("a").map { |a| a.get("href") }.compact
      else
        []
      end
    end
  end
end
