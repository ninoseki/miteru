# frozen_string_literal: true

require "bundler/setup"
require "miteru"

require "glint"
require "vcr"
require "webrick"

require 'coveralls'
Coveralls.wear!

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  def capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end
    result
  end
end

def server
  server = Glint::Server.new do |port|
    http = WEBrick::HTTPServer.new(
      BindAddress: "0.0.0.0",
      Port: port,
      Logger: WEBrick::Log.new(File.open(File::NULL, "w")),
      AccessLog: []
    )
    http.mount_proc("/admin.asp") do |_, res|
      body = "test"

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

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.configure_rspec_metadata!
  config.hook_into :webmock
  config.ignore_localhost = true
end
