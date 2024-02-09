# frozen_string_literal: true

require "colorize"

module Miteru
  class Crawler < Service
    #
    # @param [Miteru::Website] website
    #
    def call(website)
      Try[OpenSSL::SSL::SSLError, ::HTTP::Error, Addressable::URI::InvalidURIError] do
        info = "Website:#{website.info}."
        info = info.colorize(:red) if website.kits?
        logger.info(info)

        website.kits.each do |kit|
          downloader = Downloader.new(kit)
          result = downloader.result
          unless result.success?
            logger.warn("Kit:#{kit.truncated_url} failed to download - #{result.failure}.")
            next
          end
          destination = result.value!
          logger.info("Kit:#{kit.truncated_url} downloaded as #{destination}.")
          # Remove downloaded file if auto_download is not allowed
          FileUtils.rm(destination, force: true) unless auto_download?
          # Notify the kit
          notify(kit)
        end

        # Cache the website
        cache.set(website.url, website.source, ex: cache_ex) if cache?
      end.recover { nil }.value!
    end

    private

    #
    # @param [Miteru::Kit] kit
    #
    def notify(kit)
      notifiers.each do |notifier|
        result = notifier.result(kit)
        if result.success?
          logger.info("Notifier:#{notifier.name} succeeded.")
        else
          logger.warn("Notifier:#{notifier.name} failed - #{result.failure}.")
        end
      end
    end

    private

    def notifiers
      @notifiers ||= Miteru.notifiers.map(&:new)
    end
  end
end
