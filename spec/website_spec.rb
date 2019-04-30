# frozen_string_literal: true

RSpec.describe Miteru::Website do
  include_context "http_server"

  subject { described_class }

  describe "#title" do
    it "returns a String" do
      expect(subject.new("http://#{host}:#{port}/has_kit").title).to be_a(String)
    end
  end

  describe "#kits" do
    it "returns an Array" do
      kits = subject.new("http://#{host}:#{port}/has_kit").kits
      expect(kits).to be_an(Array)
      expect(kits.length).to eq(2)
    end
  end

  describe "#has_kits?" do
    context "when giving a url which contains a phishing kit" do
      it "returns true" do
        expect(subject.new("http://#{host}:#{port}/has_kit").has_kits?).to eq(true)
      end
    end

    context "when giving a url which doesn't contain a phishing kit" do
      it "returns false" do
        expect(subject.new("http://#{host}:#{port}/no_kit").has_kits?).to eq(false)
      end
    end
  end
end
