# frozen_string_literal: true

require "cgi"
require "securerandom"

module Miteru
  class Kit
    VALID_EXTENSIONS = Miteru.configuration.valid_extensions
    VALID_MIME_TYPES = Miteru.configuration.valid_mime_types

    attr_reader :url

    def initialize(url)
      @url = url
    end

    def valid?;
      valid_ext? && reachable_and_valid_mime_type?
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

    def reachable?(response)
      response.status.success?
    end

    def valid_mime_type?(response)
      mime_type = response.content_type.mime_type.to_s
      VALID_MIME_TYPES.include? mime_type
    end

    def reachable_and_valid_mime_type?
      res = HTTPClient.head(url)
      reachable?(res) && valid_mime_type?(res)
    rescue StandardError
      false
    end
  end
end
