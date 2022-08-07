# frozen_string_literal: true

RSpec.describe Miteru::Downloader do
  include_context "http_server"
  include_context "download_kits"

  describe "#download_kits" do
    subject { described_class.new(base_dir) }

    let(:sio) { StringIO.new }

    let(:logger) do
      SemanticLogger.default_level = :info
      SemanticLogger.add_appender(io: sio, formatter: :color)
      SemanticLogger["Miteru"]
    end

    before do
      WebMock.disable!
      Miteru.configuration.download_to = base_dir

      allow(Miteru).to receive(:logger).and_return(logger)
    end

    after do
      records = Miteru::Record.all
      records.each(&:delete)

      WebMock.enable!
    end

    let(:url) { "#{base_url}/has_kit" }

    context "when it runs once" do
      it "downloads a file" do
        kits = [
          Miteru::Kit.new(url + "/test.zip", "dummy"),
          Miteru::Kit.new(url + "/test.tar.gz", "dummy")
        ]
        # make validation to set attrs
        kits.each(&:valid?)

        expect(Dir.glob("#{base_dir}/*.zip").empty?).to be(true)

        subject.download_kits(kits)

        # read logger output
        SemanticLogger.flush
        sio.rewind
        out = sio.read

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
          Miteru::Kit.new(url + "/test.zip", "dummy"),
          Miteru::Kit.new(url + "/test.zip", "dummy")
        ]
        # make validation to set attrs
        kits.each(&:valid?)

        expect(Dir.glob("#{base_dir}/*.zip").empty?).to be(true)

        subject.download_kits(kits)

        download_files = Dir.glob("#{base_dir}/*.zip")
        expect(download_files.empty?).to be(false)
        expect(download_files.length).to eq(1)
      end
    end
  end
end
