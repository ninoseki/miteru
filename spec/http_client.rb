# frozen_string_literal: true

RSpec.describe Miteru::HTTPClient do
  include_context "http_server"
  include_context "download_zip_files"
  subject { Miteru::HTTPClient }

  describe ".download" do
    before { WebMock.disable! }
    after { WebMock.enable! }
    it "should download a file" do
      expect(Dir.glob("#{base_dir}/*.zip").empty?).to be(true)
      dst = subject.download("http://#{host}:#{port}/has_kit/test.zip", @path)
      expect(File.exist?(dst)).to eq(true)
    end
  end
end
