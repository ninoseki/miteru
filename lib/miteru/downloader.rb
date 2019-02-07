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

    def download_compressed_files(url, compressed_files)
      compressed_files.each do |path|
        target_url = "#{url}/#{path}"
        filename = filename_to_save(target_url)
        destination = filepath_to_download(filename)
        begin
          download_filepath = HTTPClient.download(target_url, destination)
          if duplicated?(download_filepath)
            puts "Do not download #{target_url} because there is a same hash file in the directory (SHA256: #{sha256(download_filepath)})."
            FileUtils.rm download_filepath
          else
            puts "Download #{target_url} as #{download_filepath}"
          end
        rescue Down::Error => e
          puts "Failed to download: #{target_url} (#{e})"
        end
      end
    end

    private

    def filename_to_save(url)
      filename = url.split("/").last
      extname = File.extname(filename)
      domain = URI(url).hostname

      "#{domain}_#{filename}_#{SecureRandom.alphanumeric(10)}#{extname}"
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
