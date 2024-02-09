# frozen_string_literal: true

module Miteru
  class Kit < Service
    include Concerns::UrlTruncatable

    # @return [String]
    attr_reader :url

    # @return [String]
    attr_reader :source

    # @return [Integer, nil]
    attr_reader :status

    # @return [Integer, nil]
    attr_reader :content_length

    # @return [String, nil]
    attr_reader :mime_type

    # @return [Hash, nil]
    attr_reader :headers

    #
    # @param [String] url
    # @param [String] source
    #
    def initialize(url, source:)
      super()

      @url = url
      @source = source

      @content_length = nil
      @mime_type = nil
      @status = nil
      @headers = nil
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
      @basename ||= File.basename(url)
    end

    def filename
      @filename ||= CGI.unescape(basename)
    end

    def filepath_to_download
      "#{base_dir}/#{filename_to_download}"
    end

    def downloaded?
      File.exist?(filepath_to_download)
    end

    def filesize
      return nil unless downloaded?

      File.size filepath_to_download
    end

    def filename_with_size
      return filename unless filesize

      kb = (filesize.to_f / 1024.0).ceil
      "#{filename}(#{kb}KB)"
    end

    def id
      @id ||= UUIDTools::UUID.random_create.to_s
    end

    def hostname
      @hostname ||= URI(url).hostname
    end

    private

    def filename_to_download
      "#{id}#{extname}"
    end

    def base_dir
      @base_dir ||= Miteru.config.download_to
    end

    def valid_ext?
      Miteru.config.file_extensions.include? extname
    end

    def http
      HTTP::Factory.build(raise_exception: false)
    end

    def before_validation
      Try[StandardError] do
        res = http.head(url)
        @content_length = res.content_length
        @mime_type = res.content_type.mime_type.to_s
        @status = res.status
        @headers = res.headers.to_h
      end.recover { nil }.value!
    end

    def reachable?
      status&.success?
    end

    def valid_mime_type?
      Miteru.config.file_mime_types.include? mime_type
    end

    def valid_content_length?
      content_length.to_i.positive?
    end
  end
end
