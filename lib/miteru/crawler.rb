# frozen_string_literal: true

require "csv"
require "http"
require "json"
require "parallel"
require "uri"

module Miteru
  class Crawler
    attr_reader :auto_download
    attr_reader :directory_traveling
    attr_reader :download_to
    attr_reader :size
    attr_reader :threads
    attr_reader :verbose

    URLSCAN_ENDPOINT = "https://urlscan.io/api/v1"
    OPENPHISH_ENDPOINT = "https://openphish.com"
    PHISHTANK_ENDPOINT = "http://data.phishtank.com"

    def initialize(auto_download: false, directory_traveling: false, download_to: "/tmp", post_to_slack: false, size: 100, threads: 10, verbose: false)
      @auto_download = auto_download
      @directory_traveling = directory_traveling
      @download_to = download_to
      @post_to_slack = post_to_slack
      @size = size
      @threads = threads
      @verbose = verbose
      raise ArgumentError, "size must be less than 100,000" if size > 100_000
    end

    def urlscan_feed
      url = "#{URLSCAN_ENDPOINT}/search/?q=certstream-suspicious&size=#{size}"
      res = JSON.parse(get(url))
      res["results"].map { |result| result.dig("task", "url") }
    rescue HTTPResponseError => _
      []
    end

    def openphish_feed
      res = get("#{OPENPHISH_ENDPOINT}/feed.txt")
      res.lines.map(&:chomp)
    rescue HTTPResponseError => _
      []
    end

    def phishtank_feed
      res = get("#{PHISHTANK_ENDPOINT}/data/online-valid.csv")
      table = CSV.parse(res, headers: true)
      table.map { |row| row["url"] }
    rescue HTTPResponseError => _
      []
    end

    def breakdown(url)
      begin
        uri = URI.parse(url)
      rescue URI::InvalidURIError => _
        return []
      end
      base = "#{uri.scheme}://#{uri.hostname}"
      return [base] unless directory_traveling

      segments = uri.path.split("/")
      return [base] if segments.length.zero?

      urls = (0...segments.length).map { |idx| "#{base}#{segments[0..idx].join('/')}" }
      urls.reject do |breakdowned_url|
        # Reject a url which ends with specific extension names
        %w(.htm .html .php .asp .aspx).any? { |ext| breakdowned_url.end_with? ext }
      end
    end

    def suspicious_urls
      @suspicious_urls ||= [].tap do |arr|
        urls = (urlscan_feed + openphish_feed + phishtank_feed).select { |url| url.start_with?("http://", "https://") }
        urls.map { |url| breakdown(url) }.flatten.uniq.sort.each { |url| arr << url }
      end
    end

    def execute
      puts "Loaded #{suspicious_urls.length} URLs to crawl." if verbose

      websites = []
      Parallel.each(suspicious_urls, in_threads: threads) do |url|
        website = Website.new(url)

        if website.has_kit?
          message = "#{website.url}: it might contain phishing kit(s) (#{website.compressed_files.join(', ')})."
          puts message.colorize(:light_red)
          post_message_to_slack(website.message) if post_to_slack? && valid_slack_setting?
          download_compressed_files(website.url, website.compressed_files, download_to) if auto_download?
        else
          puts "#{website.url}: it doesn't contain a phishing kit." if verbose
        end
        break
      rescue StandardError => e
        puts "Failed to load #{url} (#{e})" if verbose
      end
      websites
    end

    def self.execute(auto_download: false, directory_traveling: false, download_to: "/tmp", post_to_slack: false, size: 100, threads: 10, verbose: false)
      new(
        auto_download: auto_download,
        directory_traveling: directory_traveling,
        download_to: download_to,
        post_to_slack: post_to_slack,
        size: size,
        threads: threads,
        verbose: verbose
      ).execute
    end

    def download_compressed_files(url, compressed_files, base_dir)
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

    def post_to_slack(message)
      webhook_url = ENV["SLACK_WEBHOOK_URL"]
      raise ArgumentError, "Please set the Slack webhook URL via SLACK_WEBHOOK_URL env" unless webhook_url

      channel = ENV["SLACK_CHANNEL"] || "#general"

      payload = { text: message, channel: channel }
      HTTP.post(webhook_url, json: payload)
    end

    def post_to_slack?
      @post_to_slack
    end

    def auto_download?
      @auto_download
    end

    def valid_slack_setting?
      ENV["SLACK_WEBHOOK_URL"] != nil
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

    def get(url)
      res = HTTP.follow(max_hops: 3).get(url)
      raise HTTPResponseError if res.code != 200

      res.body.to_s
    end
  end
end
