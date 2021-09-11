# frozen_string_literal: true

RSpec.describe Miteru::Feeds do
  subject { described_class }

  describe "#suspicious_enrtries" do
    let(:url) { "http://sameurl.com" }

    before do
      entries = [
        Miteru::Entry.new(url, "dummy")
      ]
      allow(Miteru::Feeds::UrlScan).to receive_message_chain(:new, :entries).and_return(entries)
      allow(Miteru::Feeds::UrlScanPro).to receive_message_chain(:new, :entries).and_return(entries)
      allow(Miteru::Feeds::Ayashige).to receive_message_chain(:new, :entries).and_return(entries)
      allow(Miteru::Feeds::PhishingDatabase).to receive_message_chain(:new, :entries).and_return(entries)
      allow(Miteru::Feeds::PhishStats).to receive_message_chain(:new, :entries).and_return(entries)
    end

    it "returns a unique array" do
      results = subject.new.suspicious_entries

      expect(results).to be_an(Array)
      expect(results.length).to eq(1)
      expect(results.first.url).to eq(url)
    end
  end
end
