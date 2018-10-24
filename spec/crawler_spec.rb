# frozen_string_literal: true

RSpec.describe Miteru::Crawler do
  include_context "http_server"
  include_context "download_compressed_files"

  before(:each) { ENV.delete "SLACK_WEBHOOK_URL" }

  subject { Miteru::Crawler }

  describe "#valid_slack_setting?" do
    context "when set ENV['SLACK_WEBHOOK_URL']" do
      before { ENV["SLACK_WEBHOOK_URL"] = "test" }
      it "should return true" do
        expect(subject.new.valid_slack_setting?).to be(true)
      end
    end
    context "when not set ENV['SLACK_WEBHOOK_URL']" do
      it "should return false" do
        expect(subject.new.valid_slack_setting?).to be(false)
      end
    end
  end

  describe "#post_a_message_to_slack" do
    context "when not set ENV['SLACK_WEBHOOK_URL']" do
      it "should return false" do
        expect { subject.new.post_a_message_to_slack("test") }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".execute" do
    before do
      allow_any_instance_of(Miteru::Feeds).to receive(:suspicious_urls).and_return(["http://#{host}:#{port}/has_kit"])
    end
    it "should not raise any error" do
      capture(:stdout) { expect { subject.execute }.to_not raise_error }
    end
  end
end
