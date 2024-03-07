# frozen_string_literal: true

RSpec.describe Miteru::Kit do
  include_context "with fake HTTP server"

  let!(:base_url) { server.base_url }
  let!(:extname) { ".zip" }
  let!(:filename) { "test#{extname}" }
  let!(:link) { "/has_kit/#{filename}" }

  subject(:kit) { described_class.new(base_url + link, source: "dummy") }

  describe "#basename" do
    it do
      expect(kit.basename).to eq(filename)
    end
  end

  describe "#filename" do
    it do
      expect(kit.filename).to eq(filename)
    end
  end

  describe "#extname" do
    it do
      expect(kit.extname).to eq(extname)
    end
  end

  describe "#url" do
    it do
      expect(kit.url).to eq("#{base_url}#{link}")
    end
  end

  describe "#valid?" do
    it do
      expect(kit.valid?).to eq(true)
    end
  end

  describe "#filepath_to_download" do
    it do
      expect(kit.filepath_to_download).to include("/tmp/#{subject.id}#{subject.extname}")
    end
  end

  describe "#filename_with_size" do
    it do
      expect(kit.filename_with_size).to eq(filename)
    end

    context "with filesize" do
      before { allow(kit).to receive(:filesize).and_return(1024 * 1024) }
      it do
        expect(kit.filename_with_size).to eq("#{filename} (1 MB)")
      end
    end
  end

  context "when given a URL encoded link" do
    subject(:kit) { described_class.new("#{base_url}/test%201.zip", source: "dummy") }

    describe "#filename" do
      it do
        expect(kit.filename).to eq("test 1.zip")
      end
    end
  end

  context "when given an index.html" do
    subject(:kit) { described_class.new("#{base_url}/index.html", source: "dummy") }

    describe "#valid?" do
      it do
        expect(kit.valid?).to eq(false)
      end
    end
  end
end
