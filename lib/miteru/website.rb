# frozen_string_literal: true

require "oga"

module Miteru
  class Website
    attr_reader :url
    def initialize(url)
      @url = url
      build
    end

    def title
      doc.at_css("title")&.text
    end

    def compressed_files
      @compressed_files ||= doc.css("a").map do |a|
        href = a.get("href")
        [".zip", ".rar", ".7z", ".tar", ".gz"].any? { |ext| href&.end_with? ext } ? href : nil
      end.compact.map do |href|
        href.start_with?("/") ? href[1..-1] : href
      end
    end

    def ok?
      response.code == 200
    end

    def index?
      title == "Index of /"
    end

    def compressed_files?
      !compressed_files.empty?
    end

    def has_kit?
      @has_kit ||= ok? && index? && compressed_files?
    end

    def build
      doc
    end

    def unbuild
      @doc = nil
      @response = nil
      @compressed_files = nil
    end

    private

    def response
      @response ||= get
    end

    def get
      HTTPClient.get url
    end

    def doc
      @doc ||= Oga.parse_html(response.body.to_s)
    end
  end
end
