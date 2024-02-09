# frozen_string_literal: true

require "digest"
require "fileutils"

require "down/http"

module Miteru
  class Downloader < Service
    prepend MemoWise

    # @return [String]
    attr_reader :base_dir

    # @return [Miteru::Kit]
    attr_reader :kit

    #
    # <Description>
    #
    # @param [Miteru::Kit] kit
    # @param [String] base_dir
    #
    def initialize(kit, base_dir: Miteru.config.download_to)
      super()
      @kit = kit
      @base_dir = base_dir
    end

    #
    # @return [String]
    #
    def call
      destination = kit.filepath_to_download

      # downloader.download(kit.url, destination:, max_size:)
      downloader.download(kit.url, destination:, max_size:)

      unless Record.unique_sha256?(sha256(destination))
        FileUtils.rm destination
        raise UniquenessError, "Kit:#{sha256(destination)} is registered already."
      end

      # Record a kit in DB
      Record.create_by_kit_and_hash(kit, sha256: sha256(destination))
      logger.info "Download #{kit.url} as #{destination}"

      destination
    end

    private

    def timeout
      Miteru.config.download_timeout
    end

    def downloader
      Down::Http.new(ssl_context:) { |client| client.timeout(timeout) }
    end

    def ssl_context
      OpenSSL::SSL::SSLContext.new.tap do |ctx|
        ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
    end

    def max_size
      Miteru.config.file_max_size
    end

    def sha256(path)
      digest = Digest::SHA256.file(path)
      digest.hexdigest
    end
    memo_wise :sha256
  end
end
