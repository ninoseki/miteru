# frozen_string_literal: true

require "sidekiq"

require "miteru/sidekiq/jobs"

Sidekiq.configure_server do |config|
  config.redis = {url: Miteru.config.sidekiq_redis_url.to_s}
  config.default_job_options = {
    retry: Miteru.config.sidekiq_job_retry,
    expires_in: 0.second
  }
end

Sidekiq.configure_client do |config|
  config.redis = {url: Miteru.config.sidekiq_redis_url.to_s}
end
