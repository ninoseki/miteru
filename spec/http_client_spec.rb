# frozen_string_literal: true

RSpec.describe Miteru::HTTPClient do
  include_context "http_server"
  include_context "download_kits"
  subject { described_class }

  describe ".download" do
    before { WebMock.disable! }

    after { WebMock.enable! }

    it "downloads a file" do
      expect(Dir.glob("#{base_dir}/*.zip").empty?).to be(true)
      dst = subject.download("#{base_url}/has_kit/test.zip", base_dir)
      expect(File.exist?(dst)).to eq(true)
    end
  end
end
