# frozen_string_literal: true

require "digest"
require "fileutils"
require "uri"

module Miteru
  class Downloader
    attr_reader :base_dir, :memo

    def initialize(base_dir = "/tmp")
      @base_dir = base_dir
      @memo = {}
      raise ArgumentError, "#{base_dir} doesn't exist." unless Dir.exist?(base_dir)
    end

    def download_kits(kits)
      kits.each { |kit| download_kit kit }
    end

    private

    def download_kit(kit)
      destination = kit.filepath_to_download

      begin
        downloaded_as = HTTPClient.download(kit.url, destination)
      rescue Down::Error => e
        puts "Failed to download: #{kit.url} (#{e})"
        return
      end

      hash = sha256(downloaded_as)

      ActiveRecord::Base.connection_pool.with_connection do
        # Remove a downloaded file if it is not unique
        unless Record.unique_hash?(hash)
          puts "Don't download #{kit.url}. The same hash is already recorded. (SHA256: #{hash})."
          FileUtils.rm downloaded_as
          return
        end

        # Record a kit in DB
        Record.create_by_kit_and_hash(kit, hash)
        puts "Download #{kit.url} as #{downloaded_as}"
      end
    end

    def sha256(path)
      return memo[path] if memo.key?(path)

      digest = Digest::SHA256.file(path)
      hash = digest.hexdigest
      memo[path] = hash
      hash
    end
  end
end
