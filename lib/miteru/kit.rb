# frozen_string_literal: true

require "cgi"
require "securerandom"

module Miteru
  class Kit
    VALID_EXTENSIONS = Miteru.configuration.valid_extensions
    VALID_MIME_TYPES = Miteru.configuration.valid_mime_types

    attr_reader :url

    attr_reader :status
    attr_reader :content_length
    attr_reader :mime_type

    def initialize(url)
      @url = url

      @content_length = nil
      @mime_type = nil
      @status = nil
    end

    def valid?
      # make a HEAD request for the validation
      before_validation

      valid_ext? && reachable? && valid_mime_type? && valid_content_length?
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

    def before_validation
      res = HTTPClient.head(url)
      @content_length = res.content_length
      @mime_type = res.content_type.mime_type.to_s
      @status = res.status
    rescue StandardError
      # do nothing
    end

    def reachable?
      status&.success?
    end

    def valid_mime_type?
      VALID_MIME_TYPES.include? mime_type
    end

    def valid_content_length?
      content_length.to_i > 0
    end
  end
end
