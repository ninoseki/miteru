# frozen_string_literal: true

module Miteru
  module Concerns
    module UrlTruncatable
      extend ActiveSupport::Concern

      def decoded_url
        @decoded_url ||= URI.decode_www_form_component(url)
      end

      #
      # @return [String]
      #
      def truncated_url
        @truncated_url ||= decoded_url.truncate(64)
      end

      def defanged_truncated_url
        @defanged_truncated_url ||= truncated_url.to_s.gsub(".", "[.]")
      end
    end
  end
end
