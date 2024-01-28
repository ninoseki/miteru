# frozen_string_literal: true

module Miteru
  class Record < ActiveRecord::Base
    class << self
      #
      # @param [String] sha256
      #
      # @return [Boolean] true if it is unique. Otherwise false.
      #
      def unique_sha256?(sha256)
        !where(sha256:).exists?
      end

      #
      # Create a new record based on a kit
      #
      # @param [Miteru::Kit] kit
      # @param [String] sha256
      #
      # @return [Miteru::Record]
      #
      def create_by_kit_and_hash(kit, sha256:)
        record = new(
          source: kit.source,
          hostname: kit.hostname,
          url: kit.decoded_url,
          headers: kit.headers,
          filename: kit.filename,
          filesize: kit.filesize,
          mime_type: kit.mime_type,
          downloaded_as: kit.filepath_to_download,
          sha256:
        )
        record.save
        record
      rescue TypeError, ActiveRecord::RecordNotUnique
        nil
      end
    end
  end
end
