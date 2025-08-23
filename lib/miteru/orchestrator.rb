# frozen_string_literal: true

module Miteru
  class Orchestrator < Service
    def call
      logger.info("#{non_cached_websites.length} websites loaded in total.") if verbose?
      array_of_args = non_cached_websites.map { |website| [website.url, website.source] }
      Jobs::CrawleJob.perform_bulk(array_of_args, batch_size: Miteru.config.sidekiq_batch_size)
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
            logger.info("Feed:#{feed.source} downloaded.", websites: websites.length) if verbose?
            out << websites
          else
            logger.warn("Feed:#{feed.source} failed.", failure: result.failure)
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
