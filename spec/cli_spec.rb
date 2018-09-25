# frozen_string_literal: true

RSpec.describe Miteru::CLI do
  include_context "http_server"
  include_context "download_zip_files"
  subject { Miteru::CLI.new }
  before(:each) { ENV.delete "SLACK_WEBHOOK_URL" }

  describe "#execute" do
    before do
      allow_any_instance_of(Miteru::Crawler).to receive(:suspicious_urls).and_return(["http://#{host}:#{port}/has_kit"])
    end
    it "should not raise any error" do
      capture(:stdout) { Miteru::CLI.start %w(execute) }
    end
  end

  describe "#download_zip_files" do
    before { WebMock.disable! }
    after { WebMock.enable! }
    it "should download file(s)" do
      url = "http://#{host}:#{port}/has_kit"
      zip_files = ["test.zip"]
      expect(Dir.glob("#{base_dir}/*.zip").empty?).to be(true)
      capture(:stdout) { subject.download_zip_files(url, zip_files, base_dir) }
      expect(Dir.glob("#{base_dir}/*.zip").empty?).to be(false)
    end
  end
  describe "#valid_slack_setting?" do
    context "when set ENV['SLACK_WEBHOOK_URL']" do
      before { ENV["SLACK_WEBHOOK_URL"] = "test" }
      it "should return true" do
        expect(subject.valid_slack_setting?).to be(true)
      end
    end
    context "when not set ENV['SLACK_WEBHOOK_URL']" do
      it "should return false" do
        expect(subject.valid_slack_setting?).to be(false)
      end
    end
  end
  describe "#post_to_slack" do
    context "when not set ENV['SLACK_WEBHOOK_URL']" do
      it "should return false" do
        expect { subject.post_to_slack("test") }.to raise_error(ArgumentError)
      end
    end
  end
end
