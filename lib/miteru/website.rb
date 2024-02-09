# frozen_string_literal: true

require "oga"

module Miteru
  class Website < Service
    include Concerns::UrlTruncatable

    # @return [String]
    attr_reader :url

    # @return [String]
    attr_reader :source

    #
    # @param [String] url
    # @param [String] source
    #
    def initialize(url, source:)
      super()

      @url = url
      @source = source
    end

    def title
      doc&.at_css("title")&.text
    end

    def kits
      @kits ||= links.map { |link| Kit.new(link, source:) }.select(&:valid?)
    end

    def index?
      title.to_s.start_with? "Index of"
    end

    def kits?
      kits.any?
    end

    def links
      (href_links + possible_file_links).compact.uniq
    end

    def info
      "#{defanged_truncated_url} has #{kits.length} kit(s) (Source: #{source})"
    end

    private

    def timeout
      Miteru.config.http_timeout
    end

    def http
      @http ||= HTTP::Factory.build(timeout:)
    end

    def get
      http.get url
    end

    def response
      @response ||= get
    end

    def doc
      Oga.parse_html response.body.to_s
    end

    def href_links
      Try[Addressable::URI::InvalidURIError, Encoding::CompatibilityError, ::HTTP::Error, LL::ParserError,
        OpenSSL::SSL::SSLError, StatusError, ArgumentError] do
        doc.css("a").filter_map { |a| a.get("href") }.map do |href|
          normalized_href = href.start_with?("/") ? href : "/#{href}"
          normalized_url = url.end_with?("/") ? url.delete_suffix("/") : url
          normalized_url + normalized_href
        end
      end.recover { [] }.value!
    end

    def file_extensions
      Miteru.config.file_extensions
    end

    def possible_file_links
      parsed = URI.parse(url)

      segments = parsed.path.split("/")
      return [] if segments.empty?

      last = segments.last
      file_extensions.map do |ext|
        new_segments = segments[0..-2] + ["#{last}#{ext}"]
        parsed.path = new_segments.join("/")
        parsed.to_s
      end
    end
  end
end
