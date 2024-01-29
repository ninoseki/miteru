# frozen_string_literal: true

module Miteru
  class Crawler < Service
    #
    # @param [Miteru::Website] website
    #
    def call(website)
      Try[OpenSSL::SSL::SSLError, ::HTTP::Error, Addressable::URI::InvalidURIError] do
        Miteru.logger.info("Website:#{website.truncated_url} has #{website.kits.length} kit(s).")
        return unless website.kits?

        notify website

        return unless auto_download?

        website.kits.each do |kit|
          downloader = Downloader.new(kit)
          result = downloader.result
          if result.success?
            Miteru.logger.info("Kit:#{kit.truncated_url} downloaded as #{result.value!}.")
          else
            Miteru.logger.warn("Kit:#{kit.truncated_url} failed to download - #{result.failure}.")
          end
        end
      end.recover { nil }.value!
    end

    private

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
