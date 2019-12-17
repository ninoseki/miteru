# frozen_string_literal: true

RSpec.describe Miteru::Feeds::UrlScan, :vcr do
  subject { described_class }

  context "without 'size' option" do
    it "returns an Array" do
      results = subject.new.urls
      expect(results).to be_an(Array)
      expect(results.length).to eq(100)
    end
  end

  context "with 'size' option" do
    context "when size <= 10,000" do
      it "returns an Array" do
        results = subject.new(10_000).urls
        expect(results).to be_an(Array)
        expect(results.length).to eq(10_000)
      end
    end

    context "when size > 10,000" do
      it "raises an ArugmentError" do
        expect { subject.new(10_001).urls }.to raise_error(ArgumentError)
      end
    end

    context "when an error is raised" do
      before { allow(UrlScan::API).to receive(:new).and_raise(UrlScan::ResponseError, "test") }

      it "outputs a message" do
        message = capture(:stdout) { subject.new.urls }
        expect(message).to eq("Failed to load urlscan.io feed (test)\n")
      end
    end
  end
end
