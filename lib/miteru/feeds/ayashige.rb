# frozen_string_literal: true

module Miteru
  class Feeds
    class Ayashige < Base
      def initialize(base_url = "https://ayashige.herokuapp.com")
        super
      end

      def urls
        json.map { |item| item["fqdn"] }.map { |fqdn| "https://#{fqdn}" }
      end

      private

      def json
        get_json "/api/v1/domains/"
      end
    end
  end
end
