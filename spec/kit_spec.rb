# frozen_string_literal: true

RSpec.describe Miteru::Kit do

  subject { Miteru::Kit.new(base_url: "http://test.com", link: "/test.zip") }

  describe "#basename" do
    it "should return a base name" do
      expect(subject.basename).to eq("test.zip")
    end
  end

  describe "#extname" do
    it "should return a base extname" do
      expect(subject.extname).to eq(".zip")
    end
  end

  describe "#url" do
    it "should return a URL" do
      expect(subject.url).to eq("http://test.com/test.zip")
    end
  end

  describe "#valid?" do
    it "should return true" do
      expect(subject.valid?).to eq(true)
    end
  end
end
