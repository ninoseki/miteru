# frozen_string_literal: true

require "oga"

module Miteru
  class Website
    VALID_EXTENSIONS = Miteru.configuration.valid_extensions

    attr_reader :url

    def initialize(url)
      @url = url
    end

    def title
      doc&.at_css("title")&.text
    end

    def kits
      @kits ||= links.filter_map do |link|
        kit = Kit.new(link)
        kit.valid? ? kit : nil
      end
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
      kits?
    rescue Addressable::URI::InvalidURIError, ArgumentError, Encoding::CompatibilityError, HTTP::Error, LL::ParserError, OpenSSL::SSL::SSLError => _e
      false
    end

    def message
      return "It doesn't contain a phishing kit." unless kits?

      filename_with_sizes = kits.map(&:filename_with_size).join(", ")
      noun = kits.length == 1 ? "a phishing kit" : "phishing kits"
      "It might contain #{noun}: #{filename_with_sizes}."
    end

    def links
      (href_links + possible_file_links).compact.uniq
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
    rescue ArgumentError, Encoding::CompatibilityError, LL::ParserError => _e
      nil
    end

    def href_links
      if doc && ok? && index?
        doc.css("a").filter_map { |a| a.get("href") }.map do |href|
          href = href.start_with?("/") ? href : "/#{href}"
          url + href
        end
      else
        []
      end
    rescue Addressable::URI::InvalidURIError, ArgumentError, Encoding::CompatibilityError, HTTP::Error, LL::ParserError, OpenSSL::SSL::SSLError => _e
      []
    end

    def possible_file_links
      uri = URI.parse(url)

      segments = uri.path.split("/")
      return [] if segments.length.zero?

      last = segments.last
      VALID_EXTENSIONS.map do |ext|
        new_segments = segments[0..-2] + ["#{last}#{ext}"]
        uri.path = new_segments.join("/")
        uri.to_s
      end
    end
  end
end
