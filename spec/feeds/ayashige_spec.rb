# frozen_string_literal: true

RSpec.describe Miteru::Feeds::Ayashige, :vcr do
  subject { Miteru::Feeds::Ayashige }

  describe "#urls" do
    it "should return an Array" do
      results = subject.new.urls
      expect(results).to be_an(Array)
      results.all? { |url| url.start_with? /^http|^https/ }
    end
  end
end
