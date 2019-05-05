# frozen_string_literal: true

RSpec.describe Miteru::Crawler do
  include_context "http_server"
  include_context "download_kits"

  before { allow(ENV).to receive(:[]).with("SLACK_WEBHOOK_URL").and_return(nil) }

  describe ".execute" do
    before do
      allow(Miteru::Feeds).to receive_message_chain(:new, :suspicious_urls).and_return(["http://#{host}:#{port}/has_kit"])
      allow(Parallel).to receive(:processor_count).and_return(0)
    end

    it do
      capture(:stdout) { expect { described_class.execute }.not_to raise_error }
    end
  end

  describe "#threads" do
    it do
      expect(described_class.new.threads).to eq(Parallel.processor_count)
    end
  end
end
