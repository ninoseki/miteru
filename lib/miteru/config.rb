# frozen_string_literal: true

require "anyway_config"

module Miteru
  class Config < Anyway::Config
    config_name :miteru
    env_prefix ""

    attr_config(
      auto_download: false,
      database_url: URI("sqlite3:miteru.db"),
      directory_traveling: false,
      download_to: "/tmp",
      file_max_size: 1024 * 1024 * 100,
      file_extensions: [".zip", ".rar", ".7z", ".tar", ".gz"],
      file_mime_types: [
        "application/zip",
        "application/vnd.rar",
        "application/x-7z-compressed",
        "application/x-tar",
        "application/gzip"
      ],
      api_timeout: 60,
      http_timeout: 60,
      download_timeout: 60,
      sentry_dsn: nil,
      sentry_trace_sample_rate: 0.25,
      sidekiq_redis_url: nil,
      sidekiq_job_retry: 0,
      cache_redis_url: nil,
      cache_ex: nil,
      cache_prefix: "miteru:cache",
      slack_channel: "#general",
      slack_webhook_url: nil,
      threads: Parallel.processor_count,
      urlscan_api_key: nil,
      urlscan_submit_visibility: "public",
      urlscan_date_condition: "date:>now-1h",
      urlscan_base_condition: "task.method:automatic AND NOT task.source:urlscan-observe",
      verbose: false
    )

    # @!attribute [r] sentry_dsn
    #   @return [String, nil]

    # @!attribute [r] sentry_trace_sample_rate
    #   @return [Float]

    # @!attribute [r] sidekiq_redis_url
    #   @return [String, nil]

    # @!attribute [r] sidekiq_job_retry
    #   @return [Integer]

    # @!attribute [r] cache_redis_url
    #   @return [String, nil]

    # @!attribute [r] cache_ex
    #   @return [Integer, nil]

    # @!attribute [r] cache_prefix
    #   @return [String]

    # @!attribute [r] http_timeout
    #   @return [Integer]

    # @!attribute [r] api_timeout
    #   @return [Integer]

    # @!attribute [r] download_timeout
    #   @return [Integer]

    # @!attribute [rw] auto_download
    #   @return [Boolean]

    # @!attribute [rw] directory_traveling
    #   @return [Boolean]

    # @!attribute [rw] download_to
    #   @return [String]

    # @!attribute [rw] threads
    #   @return [Integer]

    # @!attribute [r] cache_redis_url
    #   @return [String, nil]

    # @!attribute [r] cache_ex
    #   @return [Integer, nil]

    # @!attribute [r] cache_prefix
    #   @return [String]

    # @!attribute [r] http_timeout
    #   @return [Integer]

    # @!attribute [r] api_timeout
    #   @return [Integer]

    # @!attribute [r] download_timeout
    #   @return [Integer]

    # @!attribute [rw] auto_download
    #   @return [Boolean]

    # @!attribute [rw] directory_traveling
    #   @return [Boolean]

    # @!attribute [rw] download_to
    #   @return [String]

    # @!attribute [rw] threads
    #   @return [Integer]

    # @!attribute [rw] verbose
    #   @return [Boolean]

    # @!attribute [r] database_url
    #   @return [URI]

    # @!attribute [r] file_max_size
    #   @return [Integer]

    # @!attribute [r] file_extensions
    #   @return [Array<String>]

    # @!attribute [r] file_mime_types
    #   @return [Array<String>]

    # @!attribute [r] slack_webhook_url
    #   @return [String, nil]

    # @!attribute [r] slack_channel
    #   @return [String]

    # @!attribute [r] urlscan_api_key
    #   @return [String, nil]

    # @!attribute [r] urlscan_submit_visibility
    #   @return [String]

    # @!attribute [r] urlscan_date_condition
    #   @return [String]

    # @!attribute [r] urlscan_base_condition
    #   @return [String]

    def database_url=(val)
      super(URI(val.to_s))
    end
  end
end
