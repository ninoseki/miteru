# frozen_string_literal: true

module Miteru
  class Kit
    VALID_EXTENSIONS = [".zip", ".rar", ".7z", ".tar", ".gz"].freeze

    attr_reader :base_url, :link

    def initialize(base_url:, link:)
      @base_url = base_url
      @link = link.start_with?("/") ? link[1..-1] : link
    end

    def valid?
      VALID_EXTENSIONS.include? extname
    end

    def extname
      File.extname(link)
    end

    def basename
      File.basename(link)
    end

    def url
      "#{base_url}/#{basename}"
    end
  end
end
