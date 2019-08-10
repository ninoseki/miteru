# frozen_string_literal: true

RSpec.describe Miteru::Crawler do
  include_context "http_server"
  include_context "download_kits"

  before { allow(ENV).to receive(:[]).with("SLACK_WEBHOOK_URL").and_return(nil) }

  describe ".execute" do
    before do
      feeds = double("feeds")
      allow(feeds).to receive(:suspicious_urls).and_return(["http://#{host}:#{port}/has_kit"])
      allow(Miteru::Feeds).to receive(:new).and_return(feeds)

      allow(Miteru.configuration).to receive(:threads).and_return(0)
    end

    it do
      capture(:stdout) { expect { described_class.execute }.not_to raise_error }
    end
  end
end
