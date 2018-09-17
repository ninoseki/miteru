
# frozen_string_literal: true

RSpec.describe Miteru::Crawler, :vcr do
  subject { Miteru::Crawler.new }
  describe "#suspicous_urls" do
    it "should return an Array" do
      results = subject.suspicous_urls
      expect(results).to be_an(Array)
      expect(results.length).to eq(100)
    end
  end
  describe "#execute" do
    before do
      allow_any_instance_of(Miteru::Crawler).to receive(:suspicous_urls).and_return(%w(http://localhost))
      allow_any_instance_of(Miteru::Website).to receive(:has_kit?).and_return(true)
    end
    it "should return an Array" do
      results = subject.execute
      expect(results).to be_an(Array)
      expect(results.length).to eq(1)
    end
  end
end

