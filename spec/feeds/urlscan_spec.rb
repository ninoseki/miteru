# frozen_string_literal: true

RSpec.describe Miteru::Feeds::UrlScan, :vcr do
  subject { Miteru::Feeds::UrlScan }

  context "without 'size' option" do
    it "should return an Array" do
      results = subject.new.urls
      expect(results).to be_an(Array)
      expect(results.length).to eq(100)
    end
  end
  context "with 'size' option" do
    context "when size <= 100,000" do
      it "should return an Array" do
        results = subject.new(size = 200).urls
        expect(results).to be_an(Array)
        expect(results.length).to eq(200)
      end
    end
    context "when size > 100,000" do
      it "should raise an ArugmentError" do
        expect { subject.new(size = 100_001).urls }.to raise_error(ArgumentError)
      end
    end
    context "when an error is raised" do
      before { allow_any_instance_of(Miteru::HTTPClient).to receive(:get).and_raise(Miteru::HTTPResponseError, "test") }
      it "should output a message" do
        message = capture(:stdout) { subject.new.urls }
        expect(message).to eq("Failed to load urlscan.io feed (test)\n")
      end
    end
  end
end
