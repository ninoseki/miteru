# frozen_string_literal: true

RSpec.describe Miteru::Kit do
  subject { described_class.new(base_url: "http://test.com", link: "/test.zip") }

  describe "#basename" do
    it "returns a base name" do
      expect(subject.basename).to eq("test.zip")
    end
  end

  describe "#extname" do
    it "returns a base extname" do
      expect(subject.extname).to eq(".zip")
    end
  end

  describe "#url" do
    it "returns a URL" do
      expect(subject.url).to eq("http://test.com/test.zip")
    end
  end

  describe "#valid?" do
    it "returns true" do
      expect(subject.valid?).to eq(true)
    end
  end
end
