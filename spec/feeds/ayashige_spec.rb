# frozen_string_literal: true

RSpec.describe Miteru::Feeds::Ayashige, :vcr do
  subject { Miteru::Feeds::Ayashige }

  describe "#urls" do
    it do
      results = subject.new.urls
      expect(results).to be_an(Array)
    end
  end
end
