# frozen_string_literal: true

require "digest"
require "fileutils"
require "uri"

module Miteru
  class Downloader
    attr_reader :base_dir
    attr_reader :memo

    def initialize(base_dir = "/tmp")
      @base_dir = base_dir
      @memo = {}
      raise ArgumentError, "#{base_dir} is not exist." unless Dir.exist?(base_dir)
    end

    def download_kits(kits)
      kits.each { |kit| download_kit kit }
    end

    private

    def download_kit(kit)
      destination = kit.download_filepath
      begin
        downloaded_filepath = HTTPClient.download(kit.url, destination)
        hash = sha256(downloaded_filepath)
        if duplicated?(hash)
          puts "Do not download #{kit.url} because there is a duplicate file in the directory (SHA256: #{hash})."
          FileUtils.rm downloaded_filepath
        else
          puts "Download #{kit.url} as #{downloaded_filepath}"
        end
      rescue Down::Error => e
        puts "Failed to download: #{kit.url} (#{e})"
      end
    end

    def filepath_to_download(filename)
      "#{base_dir}/#{filename}"
    end

    def sha256(path)
      return memo[path] if memo.key?(path)

      digest = Digest::SHA256.file(path)
      hash = digest.hexdigest
      memo[path] = hash
      hash
    end

    def sha256s
      Dir.glob("#{base_dir}/*.{zip,rar,7z,tar,gz}").map { |path| sha256(path) }
    end

    def duplicated?(hash)
      sha256s.count(hash) > 1
    end
  end
end
