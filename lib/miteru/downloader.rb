# frozen_string_literal: true

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
        begin
          download_file_path = HTTPClient.download(target_url, base_dir)
          if duplicated?(download_file_path, base_dir)
            puts "Do not download #{target_url} because there is a same hash file in the directory (SHA256: #{sha256(download_file_path)})."
            FileUtils.rm download_file_path
          else
            puts "Download #{target_url} as #{download_file_path}"
          end
        rescue Down::Error => e
          puts "Failed to download: #{target_url} (#{e})"
        end
      end
    end

    private

    def sha256(path)
      digest = Digest::SHA256.file(path)
      digest.hexdigest
    end

    def duplicated?(file_path, base_dir)
      base = sha256(file_path)
      sha256s = Dir.glob("#{base_dir}/*.zip").map { |path| sha256(path) }
      sha256s.select { |sha256| sha256 == base }.length > 1
    end
  end
end
