# frozen_string_literal: true

require "http"
require "oga"

module Miteru
  class Website
    attr_reader :url
    def initialize(url)
      @url = url
    end

    def title
      doc.at_css("title")&.text
    end

    def zip_files
      @zip_files ||= doc.css("a").map do |a|
        href = a.get("href")
        href&.end_with?(".zip") ? href : nil
      end.compact
    end

    def index?
      title == "Index of /"
    end

    def zip_files?
      !zip_files.empty?
    end

    def has_kit?
      index? && zip_files?
    end

    private

    def get
      res = HTTP.get(url)
      raise HTTPResponseError if res.code != 200

      res.body.to_s
    end

    def doc
      @doc ||= Oga.parse_html(get)
    end
  end
end
