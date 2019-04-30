# frozen_string_literal: true

RSpec.describe Miteru::Attachement do
  subject { described_class.new("https://github.com") }

  describe "#to_h" do
    it "returns a hash" do
      hash = subject.to_h
      expect(hash).to be_a(Hash)
      expect(hash.dig(:title)).to eq("github.com")
      expect(hash.dig(:title_link)).to eq("https://urlscan.io/domain/github.com")
    end
  end
end
