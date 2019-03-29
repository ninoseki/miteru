# frozen_string_literal: true

RSpec.describe Miteru::Crawler do
  include_context "http_server"
  include_context "download_kits"

  before { allow(ENV).to receive(:[]).with("SLACK_WEBHOOK_URL").and_return(nil) }

  subject { Miteru::Crawler }

  describe ".execute" do
    before do
      allow(Miteru::Feeds).to receive_message_chain(:new, :suspicious_urls).and_return(["http://#{host}:#{port}/has_kit"])
    end

    it "should not raise any error" do
      capture(:stdout) { expect { subject.execute }.to_not raise_error }
    end
  end
end
