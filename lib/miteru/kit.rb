# frozen_string_literal: true

require "cgi"
require "securerandom"

module Miteru
  class Kit
    VALID_EXTENSIONS = Miteru.configuration.valid_extensions

    attr_reader :url

    def initialize(url)
      @url = url
    end

    def valid?;
      valid_ext? && reachable?
    end

    def extname
      return ".tar.gz" if url.end_with?("tar.gz")

      File.extname(url)
    end

    def basename
      File.basename(url)
    end

    def filename
      CGI.unescape basename
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
      URI(url).hostname
    end

    def download_filename
      "#{hostname}_#{filename}_#{id}#{extname}"
    end

    def base_dir
      @base_dir ||= Miteru.configuration.download_to
    end

    def valid_ext?
      VALID_EXTENSIONS.include? extname
    end

    def reachable?
      res = HTTPClient.head(url)
      res.status.success?
    rescue StandardError
      false
    end
  end
end
