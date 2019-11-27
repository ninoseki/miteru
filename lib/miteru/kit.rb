# frozen_string_literal: true

require "cgi"
require "securerandom"

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
      return ".tar.gz" if link.end_with?("tar.gz")

      File.extname(link)
    end

    def basename
      File.basename(link)
    end

    def filename
      CGI.unescape basename
    end

    def url
      "#{base_url}/#{basename}"
    end

    def download_filepath
      "#{base_dir}/#{download_filename}"
    end

    def filesize
      return nil unless File.exist?(download_filepath)

      File.size download_filepath
    end

    def filename_with_size
      return filename unless filesize

      "#{filename}(#{filesize / 1024}KB)"
    end

    private

    def id
      @id ||= SecureRandom.hex(10)
    end

    def hostname
      URI(base_url).hostname
    end

    def download_filename
      "#{hostname}_#{filename}_#{id}#{extname}"
    end

    def base_dir
      @base_dir ||= Miteru.configuration.download_to
    end
  end
end
