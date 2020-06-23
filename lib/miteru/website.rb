# frozen_string_literal: true

require "oga"

module Miteru
  class Website
    VALID_EXTENSIONS = [".zip", ".rar", ".7z", ".tar", ".gz"].freeze

    attr_reader :url
    def initialize(url)
      @url = url
    end

    def title
      doc&.at_css("title")&.text
    end

    def kits
      if ext?
        return [] unless check(url)

        link = url.split("/").last
        base_url = url.split("/")[0..-2].join("/")
        kit = Kit.new(base_url: base_url, link: link)
        return kit.valid? ? [kit] : []
      end

      links.map do |link|
        kit = Kit.new(base_url: url, link: link.to_s)
        kit.valid? ? kit : nil
      end.compact
    end

    def ext?
      VALID_EXTENSIONS.any? { |ext| url.end_with?(ext) }
    end

    def ok?
      response.code == 200
    end

    def index?
      title.to_s.start_with? "Index of"
    end

    def kits?
      !kits.empty?
    end

    def has_kits?
      return kits? if ext?

      ok? && index? && kits?
    rescue Addressable::URI::InvalidURIError, ArgumentError, Encoding::CompatibilityError, HTTP::Error, LL::ParserError, OpenSSL::SSL::SSLError => _e
      false
    end

    def message
      return "It doesn't contain a phishing kit." unless kits?

      filename_with_sizes = kits.map(&:filename_with_size).join(", ")
      noun = kits.length == 1 ? "a phishing kit" : "phishing kits"
      "It might contain #{noun}: #{filename_with_sizes}."
    end

    private

    def response
      @response ||= get
    end

    def check(url)
      res = HTTPClient.head(url)
      res.status.success?
    rescue StandardError
      false
    end

    def get
      HTTPClient.get url
    end

    def doc
      @doc ||= parse_html(response.body.to_s)
    end

    def parse_html(html)
      Oga.parse_html(html)
    rescue ArgumentError, Encoding::CompatibilityError, LL::ParserError => _e
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
