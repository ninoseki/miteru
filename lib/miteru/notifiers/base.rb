# frozen_string_literal: true

module Miteru
  module Notifiers
    class Base < Service
      def call(website)
        raise NotImplementedError
      end

      def callable?
        raise NotImplementedError
      end

      def name
        @name ||= self.class.to_s.split("::").last
      end

      class << self
        def inherited(child)
          super
          Miteru.notifiers << child
        end
      end
    end
  end
end
