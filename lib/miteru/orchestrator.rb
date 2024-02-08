# frozen_string_literal: true

module Miteru
  class Orchestrator < Service
    def call
      Miteru.logger.info("#{non_cached_websites.length} websites loaded in total.") if verbose?

      if Miteru.sidekiq?
        non_cached_websites.each do |website|
          Jobs::CrawleJob.perform_async(website.url, website.source)
          Miteru.logger.info("Website:#{website.truncated_url} crawler job queued.") if verbose?
        end
      else
        Miteru.logger.info("Use #{threads} thread(s).") if verbose?
        Parallel.each(non_cached_websites, in_threads: threads) do |website|
          Miteru.logger.info("Website:#{website.truncated_url} crawling started.") if verbose?

          result = Crawler.result(website)
          if result.success?
            Miteru.logger.info("Crawler:#{website.truncated_url} succeeded.")
          else
            Miteru.logger.info("Crawler:#{website.truncated_url} failed - #{result.failure}.")
          end
        end
      end
    end

    #
    # @return [Array<Miteru::Website>]
    #
    def websites
      @websites ||= [].tap do |out|
        feeds.each do |feed|
          result = feed.result
          if result.success?
            websites = result.value!
            Miteru.logger.info("Feed:#{feed.source} has #{websites.length} websites.") if verbose?
            out << websites
          else
            Miteru.logger.warn("Feed:#{feed.source} failed - #{result.failure}")
          end
        end
      end.flatten.uniq(&:url)
    end

    def non_cached_websites
      return websites unless cache?

      websites.reject { |website| cache.cached?(website.url) }
    end

    #
    # @return [Array<Miteru::Feeds::Base>]
    #
    def feeds
      Miteru.feeds.map(&:new)
    end

    private

    def cache?
      Miteru.cache?
    end

    def cache
      Miteru.cache
    end

    def threads
      Miteru.config.threads
    end

    def verbose?
      Miteru.config.verbose
    end
  end
end
