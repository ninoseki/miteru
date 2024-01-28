# frozen_string_literal: true

require "http"

module Miteru
  class Error < StandardError; end

  class FileSizeError < Error; end

  class DownloadError < Error; end

  class UniquenessError < Error; end

  class StatusError < ::HTTP::Error
    # @return [Integer]
    attr_reader :status_code

    # @return [String, nil]
    attr_reader :body

    #
    # @param [String] msg
    # @param [Integer] status_code
    # @param [String, nil] body
    #
    def initialize(msg, status_code, body)
      super(msg)

      @status_code = status_code
      @body = body
    end

    def detail
      {status_code:, body:}
    end
  end
end
