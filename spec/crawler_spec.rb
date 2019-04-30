# frozen_string_literal: true

RSpec.describe Miteru::Crawler do
  include_context "http_server"
  include_context "download_kits"

  subject { described_class }

  before { allow(ENV).to receive(:[]).with("SLACK_WEBHOOK_URL").and_return(nil) }

  describe ".execute" do
    before do
      allow(Miteru::Feeds).to receive_message_chain(:new, :suspicious_urls).and_return(["http://#{host}:#{port}/has_kit"])
      allow(Parallel).to receive(:processor_count).and_return(0)
    end

    it "does not raise any error" do
      capture(:stdout) { expect { subject.execute }.not_to raise_error }
    end
  end
end
