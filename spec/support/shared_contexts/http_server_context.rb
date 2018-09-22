# frozen_string_literal: true

require "glint"
require "webrick"

def server
  server = Glint::Server.new do |port|
    http = WEBrick::HTTPServer.new(
      BindAddress: "0.0.0.0",
      Port: port,
      Logger: WEBrick::Log.new(File.open(File::NULL, "w")),
      AccessLog: []
    )
    http.mount_proc("/has_kit") do |_, res|
      path = File.expand_path("../../fixtures/index.html", __dir__)
      body = File.read(path)

      res.status = 200
      res.content_length = body.size
      res.content_type = 'text/plain'
      res.body = body
    end

    http.mount_proc("/has_kit/test.zip") do |_, res|
      path = File.expand_path("../../fixtures/test.zip", __dir__)
      body = File.read(path)

      res.status = 200
      res.content_length = body.size
      res.content_type = 'application/zip'
      res.body = body
    end

    http.mount_proc("/no_kit") do |_, res|
      body = "None"

      res.status = 200
      res.content_length = body.size
      res.content_type = 'text/plain'
      res.body = body
    end

    trap(:INT) { http.shutdown }
    trap(:TERM) { http.shutdown }
    http.start
  end
  Glint::Server.info[:http_server] = {
    host: "0.0.0.0",
    port: server.port
  }
  server
end

RSpec.shared_context "http_server" do
  before(:all) {
    @server = server
    @server.start
  }
  after(:all) { @server.stop }

  let(:host) { "0.0.0.0" }
  let(:port) { @server.port }
end
