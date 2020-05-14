# frozen_string_literal: true

RSpec.describe Miteru::Feeds::PhishStats, :vcr do
  subject { described_class }

  describe "#urls" do
    it "returns an Array" do
      results = subject.new.urls
      expect(results).to be_an(Array)
      results.all? { |url| url.start_with?(/^http|^https/) }
    end
  end
end
