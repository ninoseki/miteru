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
        Miteru.logger.info(info)

        website.kits.each do |kit|
          downloader = Downloader.new(kit)
          result = downloader.result

          unless result.success?
            Miteru.logger.warn("Kit:#{kit.truncated_url} failed to download - #{result.failure}.")
            next
          end

          destination = result.value!
          Miteru.logger.info("Kit:#{kit.truncated_url} downloaded as #{destination}.")
          # Remove downloaded file if auto_download is not allowed
          FileUtils.rm(destination, force: true) unless auto_download?
          # Notify the website
          notify website
        end

        # Cache the website
        cache.set(website.url, website.source, ex: cache_ex) if cache?
      end.recover { nil }.value!
    end

    private

    def cache?
      Miteru.cache?
    end

    def cache
      Miteru.cache
    end

    def cache_ex
      Miteru.config.cache_ex
    end

    def auto_download?
      Miteru.config.auto_download
    end

    #
    # @param [Miteru::Website] website
    #
    def notify(website)
      notifiers.each do |notifier|
        result = notifier.result(website)
        if result.success?
          Miteru.logger.info("Notifier:#{notifier.name} succeeded.")
        else
          Miteru.logger.warn("Notifier:#{notifier.name} failed - #{result.failure}.")
        end
      end
    end

    #
    # @return [Array<Miteru::Notifiers::Base>]
    #
    def notifiers
      @notifiers ||= Miteru.notifiers.map(&:new)
    end
  end
end
