# frozen_string_literal: true

module Miteru
  class Orchestrator < Service
    def call
      logger.info("#{non_cached_websites.length} websites loaded in total.") if verbose?

      if sidekiq?
        sidekiq_call
      else
        parallel_call
      end
    end

    def sidekiq_call
      non_cached_websites.each do |website|
        Jobs::CrawleJob.perform_async(website.url, website.source)
        logger.info("Website:#{website.truncated_url} crawler job queued.") if verbose?
      end
    end

    def parallel_call
      logger.info("Use #{threads} thread(s).") if verbose?
      Parallel.each(non_cached_websites, in_threads: threads) do |website|
        logger.info("Website:#{website.truncated_url} crawling started.") if verbose?
        result = Crawler.result(website)
        if result.success?
          logger.info("Crawler:#{website.truncated_url} succeeded.")
        else
          logger.info("Crawler:#{website.truncated_url} failed - #{result.failure}.")
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
            logger.info("Feed:#{feed.source} has #{websites.length} websites.") if verbose?
            out << websites
          else
            logger.warn("Feed:#{feed.source} failed - #{result.failure}")
          end
        end
      end.flatten.uniq(&:url)
    end

    #
    # @return [Array<Miteru::Website>]
    #
    def non_cached_websites
      @non_cached_websites ||= [].tap do |out|
        out << if cache?
          websites.reject { |website| cache.cached?(website.url) }
        else
          websites
        end
      end.flatten.uniq(&:url)
    end

    #
    # @return [Array<Miteru::Feeds::Base>]
    #
    def feeds
      @feeds ||= Miteru.feeds.map(&:new)
    end
  end
end
