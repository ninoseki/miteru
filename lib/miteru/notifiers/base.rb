# frozen_string_literal: true

module Miteru
  module Notifiers
    class Base
      def notify(website)
        raise NotImplementedError
      end

      def notifiable?
        raise NotImplementedError
      end
    end
  end
end
