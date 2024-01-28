# frozen_string_literal: true

# Rack
require "rack"
require "rack/session"
require "rackup"

require "rack/handler/puma"

# Sidekiq
require "sidekiq/web"

module Miteru
  module Web
    class App
      class << self
        def instance
          Rack::Builder.new do
            use Rack::Session::Cookie, secret: SecureRandom.hex(32), same_site: true, max_age: 86_400

            map "/" do
              run Sidekiq::Web
            end

            run App.new
          end.to_app
        end

        def run!(port: 9292, host: "localhost", threads: "0:3", verbose: false, worker_timeout: 60, open: true)
          Rackup::Handler::Puma.run(
            instance,
            Port: port,
            Host: host,
            Threads: threads,
            Verbose: verbose,
            worker_timeout:
          )
        end
      end
    end
  end
end
