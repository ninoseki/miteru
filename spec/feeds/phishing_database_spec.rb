# frozen_string_literal: true

RSpec.describe Miteru::Feeds::PhishingDatabase, :vcr do
  subject { described_class }

  describe "#urls" do
    it do
      results = subject.new.urls
      expect(results).to be_an(Array)
    end
  end
end
