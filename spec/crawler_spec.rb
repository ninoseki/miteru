# frozen_string_literal: true

RSpec.describe Miteru::Crawler do
  include_context "http_server"
  include_context "download_compressed_files"

  before { allow(ENV).to receive(:[]).with("SLACK_WEBHOOK_URL").and_return(nil) }

  subject { Miteru::Crawler }

  describe ".execute" do
    before do
      allow_any_instance_of(Miteru::Feeds).to receive(:suspicious_urls).and_return(["http://#{host}:#{port}/has_kit"])
    end
    it "should not raise any error" do
      capture(:stdout) { expect { subject.execute }.to_not raise_error }
    end
  end
end
