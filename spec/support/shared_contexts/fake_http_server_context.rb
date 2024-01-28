# frozen_string_literal: true

require "capybara"

class FakeHTTP
  extend Forwardable

  attr_reader :req

  def initialize(env)
    @req = Rack::Request.new(env)
  end

  def_delegators :req, :path_info

  def call
    case path_info
    when "/has_kit"
      ["200", {"Content-Type" => "text/html"}, [File.read(File.expand_path("../../fixtures/index.html", __dir__))]]
    when "/has_kit/test.tar.gz"
      [
        "200",
        {"Content-Type" => "application/gzip"},
        [File.binread(File.expand_path("../../fixtures/test.tar.gz", __dir__))]
      ]
    when "/has_kit/test.zip"
      [
        "200",
        {"Content-Type" => "application/zip"},
        [File.binread(File.expand_path("../../fixtures/test.tar.gz", __dir__))]
      ]
    else
      ["404", {"Content-Type" => "application/text"}, "404"]
    end
  end

  class << self
    def call(env)
      new(env).call
    end
  end
end

RSpec.shared_context "with fake HTTP server" do
  let_it_be(:server) do
    server = Capybara::Server.new(FakeHTTP)
    server.boot
    server
  end
end
