# frozen_string_literal: true

module Miteru
  class Feeds
    class Base < Service
      IGNORE_EXTENSIONS = %w[.htm .html .php .asp .aspx .exe .txt].freeze

      # @return [String]
      attr_reader :base_url

      # @return [Hash]
      attr_reader :headers

      #
      # @param [String] base_url
      #
      def initialize(base_url)
        super()

        @base_url = base_url
        @headers = {}
      end

      def source
        @source ||= self.class.to_s.split("::").last
      end

      #
      # Return URLs
      #
      # @return [Array<String>] URLs
      #
      def urls
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      #
      # Return decomposed URLs
      #
      # @return [Array<String>] Decomposed URLs
      #
      def decomposed_urls
        urls.uniq.select { |url| url.start_with?("http://", "https://") }.map { |url| decompose(url) }.flatten.uniq
      end

      #
      # @return [Array<Miteru::Website>]
      #
      def call
        decomposed_urls.map { |url| Website.new(url, source:) }
      end

      class << self
        def inherited(child)
          super
          Miteru.feeds << child
        end
      end

      private

      def timeout
        Miteru.config.api_timeout
      end

      def directory_traveling?
        Miteru.config.directory_traveling
      end

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
      # Decompose a URL into URLs
      #
      # @param [String] url
      #
      # @return [Array<String>]
      #
      def decompose(url)
        Try[URI::InvalidURIError] do
          parsed = URI.parse(url)

          base = "#{parsed.scheme}://#{parsed.hostname}"
          return [base] unless directory_traveling?

          segments = parsed.path.split("/")
          return [base] if segments.empty?

          urls = (0...segments.length).map { |idx| "#{base}#{segments[0..idx].join("/")}" }
          urls.reject { |url| invalid_extension? url }
        end.recover { [] }.value!
      end

      #
      # @return [::HTTP::Client]
      #
      def http
        @http ||= HTTP::Factory.build(headers:, timeout:)
      end

      #
      # @param [String] path
      #
      # @return [URI]
      #
      def url_for(path)
        URI.join base_url, path
      end

      #
      # @param [String] path
      # @param [Hash, nil] params
      #
      # @return [::HTTP::Response]
      #
      def get(path, params: nil)
        http.get(url_for(path), params:)
      end

      #
      # @param [String] path
      # @param [Hash, nil] params
      #
      # @return [Hash]
      #
      def get_json(path, params: nil)
        res = get(path, params:)
        JSON.parse res.body.to_s
      end
    end
  end
end
