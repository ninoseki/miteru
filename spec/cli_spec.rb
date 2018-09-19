# frozen_string_literal: true

RSpec.describe Miteru::CLI do
  include_context "http_server"
  include_context "download_zip_files"
  subject { Miteru::CLI.new }
  before(:each) { ENV.clear }
  describe "#download_zip_files" do
    it "should download file(s)" do
      url = "http://#{host}:#{port}/has_kit"
      zip_files = ["test.zip"]

      expect(Dir.glob("#{base_dir}/*.zip").empty?).to be(true)
      subject.download_zip_files(url, zip_files, @path)
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
