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
        with_db_connection { Crawler.call(website) }
      end
    end
  end
end
