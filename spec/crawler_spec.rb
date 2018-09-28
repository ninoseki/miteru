# frozen_string_literal: true

RSpec.describe Miteru::Crawler, :vcr do
  include_context "http_server"
  subject { Miteru::Crawler }

  describe "#breakdown" do
    context "when given an url without path" do
      it "should return an Array (length == 1)" do
        results = subject.new.breakdown("http://test.com")
        expect(results).to be_an(Array)
        expect(results.length).to eq(1)
      end
    end
    context "when given an url with path" do
      context "when disabling directory_traveling" do
        it "should return an Array (length == 1)" do
          results = subject.new.breakdown("http://test.com/test/test/index.html")
          expect(results).to be_an(Array)
          expect(results.length).to eq(1)
          expect(results.first).to eq("http://test.com")
        end
      end
      context "when enabling directory_traveling" do
        it "should return an Array (length == 3)" do
          results = subject.new(directory_traveling: true).breakdown("http://test.com/test/test/index.html")
          expect(results).to be_an(Array)
          expect(results.length).to eq(3)
          expect(results).to eq(["http://test.com", "http://test.com/test", "http://test.com/test/test"])
        end
      end
    end
  end
  describe "#urlscan_feed" do
    context "without 'size' option" do
      it "should return an Array" do
        results = subject.new.urlscan_feed
        expect(results).to be_an(Array)
        expect(results.length).to eq(100)
      end
    end
    context "with 'size' option" do
      context "when size <= 100,000" do
        it "should return an Array" do
          results = subject.new(size: 200).urlscan_feed
          expect(results).to be_an(Array)
          expect(results.length).to eq(200)
        end
      end
      context "when size > 100,000" do
        it "should raise an ArugmentError" do
          expect { subject.new(size: 100_001).urlscan_feed }.to raise_error(ArgumentError)
        end
      end
    end
  end
  describe "#openphish_feed" do
    it "should return an Array" do
      results = subject.new.openphish_feed
      expect(results).to be_an(Array)
    end
  end
  describe "#suspicious_urls" do
    it "should return an Array" do
      results = subject.new.suspicious_urls
      expect(results).to be_an(Array)
      expect(results.length).to eq(results.uniq.length)
    end
  end
  describe ".execute" do
    before do
      allow_any_instance_of(Miteru::Crawler).to receive(:suspicious_urls).and_return(["http://#{host}:#{port}/has_kit"])
    end
    it "should return an Array" do
      results = subject.execute
      expect(results).to be_an(Array)
      expect(results.length).to eq(1)
    end
  end
end
