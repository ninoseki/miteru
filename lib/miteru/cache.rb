require "redis"

module Miteru
  class Cache < Service
    # @return [String]
    attr_reader :url

    #
    # @param [String] url
    #
    def initialize(url)
      super()
      @url = url
    end

    #
    # @param [String] key
    # @param [String] value
    # @param [Integer. nil] ex
    #
    def set(key, value, ex:)
      value = redis.set("#{cache_prefix}:#{key}", value, ex:)
      logger.info("Cache:#{key} is set.") if verbose?
      value
    end

    #
    # @param [String] key
    #
    def cached?(key)
      value = redis.exists?("#{cache_prefix}:#{key}")
      logger.info("Cache:#{key} found.") if verbose?
      value
    end

    private

    #
    # @return [Redis]
    #
    def redis
      @redis ||= Redis.new(url:)
    end
  end
end
