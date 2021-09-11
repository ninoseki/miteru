# frozen_string_literal: true

require "active_record"

module Miteru
  class Record < ActiveRecord::Base
    class << self
      #
      # Check uniqueness of a record by a hash
      #
      # @param [String] hash
      #
      # @return [Boolean] true if it is unique. Otherwise false.
      #
      def unique_hash?(hash)
        record = find_by(hash: hash)
        return true if record.nil?

        false
      end

      #
      # Create a new record based on a kit
      #
      # @param [Miteru::Kit] kit
      # @param [String] hash
      #
      # @return [Miteru::Record]
      #
      def create_by_kit_and_hash(kit, hash)
        record = new(
          hash: hash,
          source: kit.source,
          hostname: kit.hostname,
          url: kit.decoded_url,
          headers: kit.headers,
          filename: kit.filename,
          filesize: kit.filesize,
          mime_type: kit.mime_type,
          downloaded_as: kit.filepath_to_download
        )
        record.save
        record
      rescue TypeError, ActiveRecord::RecordNotUnique => _e
        nil
      end
    end
  end
end
