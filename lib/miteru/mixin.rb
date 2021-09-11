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

      #
      # Breakdown a URL into URLs
      #
      # @param [String] url
      # @param [Boolean] enable_directory_traveling
      #
      # @return [Array<String>]
      #
      def breakdown(url, enable_directory_traveling)
        begin
          uri = URI.parse(url)
        rescue URI::InvalidURIError => _e
          return []
        end

        base = "#{uri.scheme}://#{uri.hostname}"
        return [base] unless enable_directory_traveling

        segments = uri.path.split("/")
        return [base] if segments.length.zero?

        urls = (0...segments.length).map { |idx| "#{base}#{segments[0..idx].join("/")}" }

        urls.reject do |breakdowned_url|
          # Reject a url which ends with specific extension names
          invalid_extension? breakdowned_url
        end
      end
    end
  end
end
