# frozen_string_literal: true

require "sidekiq"

module Miteru
  module Jobs
    class CrawleJob
      include Sidekiq::Job
      include Concerns::DatabaseConnectable

      #
      # @param [String] url
      # @param [String] source
      #
      def perform(url, source)
        website = Miteru::Website.new(url, source:)
        with_db_connection do
          result = Crawler.result(website)
          if result.success?
            Miteru.logger.info("Crawler:#{website.truncated_url} succeeded.")
          else
            Miteru.logger.info("Crawler:#{website.truncated_url} failed - #{result.failure}.")
          end
        end
      end
    end
  end
end
