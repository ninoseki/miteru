# frozen_string_literal: true

RSpec.describe Miteru::Kit do
  subject { described_class.new(base_url + link) }

  let(:base_url) { "http://test.com" }
  let(:extname) { ".zip" }
  let(:filename) { "test#{extname}" }
  let(:link) { "/#{filename}" }

  before do
    allow(subject).to receive(:reachable_and_valid_mime_type?).and_return(true)
  end

  describe "#basename" do
    it "returns a base name" do
      expect(subject.basename).to eq(filename)
    end
  end

  describe "#filename" do
    it do
      expect(subject.filename).to eq(filename)
    end
  end

  describe "#extname" do
    it "returns a base extname" do
      expect(subject.extname).to eq(extname)
    end
  end

  describe "#url" do
    it "returns a URL" do
      expect(subject.url).to eq("#{base_url}#{link}")
    end
  end

  describe "#valid?" do
    it "returns true" do
      expect(subject.valid?).to eq(true)
    end
  end

  describe "#download_filepath" do
    it do
      expect(subject.download_filepath).to include("/tmp/test.com_test.zip_")
    end
  end

  describe "#filename_with_size" do
    it do
      expect(subject.filename_with_size).to eq(filename)
    end
  end

  context "when given a URL encoded link" do
    subject { described_class.new "http://test.com/test%201.zip" }

    describe "#filename" do
      it do
        expect(subject.filename).to eq("test 1.zip")
      end
    end
  end
end
