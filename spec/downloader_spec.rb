# frozen_string_literal: true

RSpec.describe Miteru::Downloader do
  include_context "http_server"
  include_context "download_compressed_files"

  describe "#download_compressed_files" do
    subject { Miteru::Downloader.new(base_dir) }

    before { WebMock.disable! }
    after { WebMock.enable! }
    context "when it runs once" do
      it "should download a file" do
        url = "http://#{host}:#{port}/has_kit"
        compressed_files = ["test.zip", "test.tar"]
        expect(Dir.glob("#{base_dir}/*.zip").empty?).to be(true)

        out = capture(:stdout) { subject.download_compressed_files(url, compressed_files) }
        lines = out.split("\n")
        expect(lines.length).to eq(2)
        expect(lines.first.end_with?(".zip")).to be(true)
        expect(lines.last.end_with?(".tar")).to be(true)

        download_files = Dir.glob("#{base_dir}/*.zip")
        expect(download_files.empty?).to be(false)
        expect(download_files.length).to eq(1)

        download_files = Dir.glob("#{base_dir}/*.tar")
        expect(download_files.empty?).to be(false)
        expect(download_files.length).to eq(1)
      end
    end
    context "when it runs multiple times" do
      it "should remove duplicated files" do
        url = "http://#{host}:#{port}/has_kit"
        compressed_files = ["test.zip"]
        expect(Dir.glob("#{base_dir}/*.zip").empty?).to be(true)

        capture(:stdout) { subject.download_compressed_files(url, compressed_files) }
        capture(:stdout) { subject.download_compressed_files(url, compressed_files) }
        out = capture(:stdout) { subject.download_compressed_files(url, compressed_files) }
        expect(out.start_with?("Do not download")).to be(true)

        download_files = Dir.glob("#{base_dir}/*.zip")
        expect(download_files.empty?).to be(false)
        expect(download_files.length).to eq(1)
      end
    end
  end
end
