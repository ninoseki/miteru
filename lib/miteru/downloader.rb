# frozen_string_literal: true

require "digest"
require "fileutils"
require "uri"

module Miteru
  class Downloader
    attr_reader :base_dir

    def initialize(base_dir = "/tmp")
      @base_dir = base_dir
      raise ArgumentError, "#{base_dir} is not existing." unless Dir.exist?(base_dir)
    end

    def download_kits(kits)
      kits.each do |kit|
        filename = download_filename(kit)
        destination = filepath_to_download(filename)
        begin
          downloaded_filepath = HTTPClient.download(kit.url, destination)
          if duplicated?(downloaded_filepath)
            puts "Do not download #{kit.url} because there is a file that has a same hash value in the directory (SHA256: #{sha256(downloaded_filepath)})."
            FileUtils.rm downloaded_filepath
          else
            puts "Download #{kit.url} as #{downloaded_filepath}"
          end
        rescue Down::Error => e
          puts "Failed to download: #{kit.url} (#{e})"
        end
      end
    end

    private

    def download_filename(kit)
      domain = URI(kit.base_url).hostname

      "#{domain}_#{kit.basename}_#{SecureRandom.alphanumeric(10)}#{kit.extname}"
    end

    def filepath_to_download(filename)
      "#{base_dir}/#{filename}"
    end

    def sha256(path)
      digest = Digest::SHA256.file(path)
      digest.hexdigest
    end

    def duplicated?(file_path)
      base = sha256(file_path)
      sha256s = Dir.glob("#{base_dir}/*.{zip,rar,7z,tar,gz}").map { |path| sha256(path) }
      sha256s.select { |sha256| sha256 == base }.length > 1
    end
  end
end
