# frozen_string_literal: true

RSpec.describe Miteru::Downloader do
  include_context "http_server"
  include_context "download_zip_files"
  subject { Miteru::Downloader }
  describe "#download" do
    it "should download a file" do
      expect(File.exist?("#{base_dir}/test.zip")).to eq(false)
      subject.download("http://#{host}:#{port}/has_kit/test.zip", @path)
      expect(File.exist?("#{base_dir}/test.zip")).to eq(true)
    end
  end
end

