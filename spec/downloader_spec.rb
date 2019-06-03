# frozen_string_literal: true

RSpec.describe Miteru::Downloader do
  include_context "http_server"
  include_context "download_kits"

  describe "#download_kits" do
    subject { described_class.new(base_dir) }

    before { WebMock.disable! }

    after { WebMock.enable! }

    let(:url) { "#{base_url}/has_kit" }

    context "when it runs once" do
      it "downloads a file" do
        kits = [
          Miteru::Kit.new(base_url: url, link: "test.zip"),
          Miteru::Kit.new(base_url: url, link: "test.tar.gz")
        ]
        expect(Dir.glob("#{base_dir}/*.zip").empty?).to be(true)

        out = capture(:stdout) { subject.download_kits(kits) }
        lines = out.split("\n")
        expect(lines.length).to eq(2)
        expect(lines.first.end_with?(".zip")).to be(true)
        expect(lines.last.end_with?(".tar.gz")).to be(true)

        download_files = Dir.glob("#{base_dir}/*.zip")
        expect(download_files.empty?).to be(false)
        expect(download_files.length).to eq(1)

        download_files = Dir.glob("#{base_dir}/*.tar.gz")
        expect(download_files.empty?).to be(false)
        expect(download_files.length).to eq(1)
      end
    end

    context "when it runs multiple times" do
      it "removes duplicated files" do
        kits = [
          Miteru::Kit.new(base_url: url, link: "test.zip")
        ]
        expect(Dir.glob("#{base_dir}/*.zip").empty?).to be(true)

        capture(:stdout) { subject.download_kits(kits) }
        capture(:stdout) { subject.download_kits(kits) }
        out = capture(:stdout) { subject.download_kits(kits) }
        expect(out.start_with?("Do not download")).to be(true)

        download_files = Dir.glob("#{base_dir}/*.zip")
        expect(download_files.empty?).to be(false)
        expect(download_files.length).to eq(1)
      end
    end
  end
end
