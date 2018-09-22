# frozen_string_literal: true

RSpec.describe Miteru::Crawler, :vcr do
  include_context "http_server"
  subject { Miteru::Crawler }
  describe "#suspicous_urls" do
    context "without 'size' option" do
      it "should return an Array" do
        results = subject.new.suspicous_urls
        expect(results).to be_an(Array)
        expect(results.length).to eq(100)
      end
    end
    context "with 'size' option" do
      context "when size <= 100,000" do
        it "should return an Array" do
          results = subject.new(size: 200).suspicous_urls
          expect(results).to be_an(Array)
          expect(results.length).to eq(200)
        end
      end
      context "when size > 100,000" do
        it "should raise an ArugmentError" do
          expect { subject.new(size: 100_001).suspicous_urls }.to raise_error(ArgumentError)
        end
      end
    end
  end
  describe ".execute" do
    before do
      allow_any_instance_of(Miteru::Crawler).to receive(:suspicous_urls).and_return(["http://#{host}:#{port}/has_kit"])
    end
    it "should return an Array" do
      results = subject.execute
      expect(results).to be_an(Array)
      expect(results.length).to eq(1)
    end
  end
end
