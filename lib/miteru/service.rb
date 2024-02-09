# frozen_string_literal: true

module Miteru
  #
  # Base class for services
  #
  class Service
    include Dry::Monads[:result, :try]

    def call(*args, **kwargs)
      raise NotImplementedError, "You must implement #{self.class}##{__method__}"
    end

    def result(...)
      Try[StandardError] { call(...) }.to_result
    end

    class << self
      def call(...)
        new.call(...)
      end

      def result(...)
        new.result(...)
      end
    end

    private

    def auto_download?
      Miteru.config.auto_download
    end

    #
    # @return [SemanticLogger]
    #
    def logger
      Miteru.logger
    end

    def cache?
      Miteru.cache?
    end

    def sidekiq?
      Miteru.sidekiq?
    end

    #
    # @return [Miteru::Cache]
    #
    def cache
      Miteru.cache
    end

    def threads
      Miteru.config.threads
    end

    def verbose?
      Miteru.config.verbose
    end

    def cache_prefix
      Miteru.config.cache_prefix
    end

    def cache_ex
      Miteru.config.cache_ex
    end
  end
end
