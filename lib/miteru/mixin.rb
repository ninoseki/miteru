# frozen_string_literal: true

module Miteru
  module Mixins
    module URL
      IGNORE_EXTENSIONS = %w[.htm .html .php .asp .aspx .exe .txt].freeze

      #
      # Validate extension of a URL
      #
      # @param [String] url
      #
      # @return [Boolean]
      #
      def invalid_extension?(url)
        IGNORE_EXTENSIONS.any? { |ext| url.end_with? ext }
      end
    end
  end
end
