# frozen_string_literal: true

RSpec.describe Miteru::Feeds do
  subject { described_class }

  describe "#breakdown" do
    context "when given an url without path" do
      it "returns an Array (length == 1)" do
        results = subject.new.breakdown("http://test.com")
        expect(results).to be_an(Array)
        expect(results.length).to eq(1)
      end
    end

    context "when given an url with path" do
      context "when disabling directory_traveling" do
        it "returns an Array (length == 1)" do
          results = subject.new.breakdown("http://test.com/test/test/index.html")
          expect(results).to be_an(Array)
          expect(results.length).to eq(1)
          expect(results.first).to eq("http://test.com")
        end
      end

      context "when enabling directory_traveling" do
        before do
          allow(Miteru.configuration).to receive(:directory_traveling?).and_return(true)
        end

        it do
          results = subject.new.breakdown("http://test.com/test/test/index.html")
          expect(results).to eq(["http://test.com", "http://test.com/test", "http://test.com/test.zip", "http://test.com/test.rar", "http://test.com/test.7z", "http://test.com/test.tar", "http://test.com/test.gz", "http://test.com/test/test", "http://test.com/test/test.zip", "http://test.com/test/test.rar", "http://test.com/test/test.7z", "http://test.com/test/test.tar", "http://test.com/test/test.gz"])
        end

        it do
          results = subject.new.breakdown("http://test.com/test/")
          expect(results).to eq(["http://test.com", "http://test.com/test", "http://test.com/test.zip", "http://test.com/test.rar", "http://test.com/test.7z", "http://test.com/test.tar", "http://test.com/test.gz"])
        end

        it do
          results = subject.new.breakdown("http://test.com/test")
          expect(results).to eq(["http://test.com", "http://test.com/test", "http://test.com/test.zip", "http://test.com/test.rar", "http://test.com/test.7z", "http://test.com/test.tar", "http://test.com/test.gz"])
        end
      end
    end
  end

  describe "#suspicious_urls" do
    let(:url) { "http://sameurl.com" }

    before do
      allow(Miteru::Feeds::UrlScan).to receive_message_chain(:new, :urls).and_return([url])
      allow(Miteru::Feeds::UrlScanPro).to receive_message_chain(:new, :urls).and_return([url])
      allow(Miteru::Feeds::Ayashige).to receive_message_chain(:new, :urls).and_return([url])
      allow(Miteru::Feeds::PhishingDatabase).to receive_message_chain(:new, :urls).and_return([url])
      allow(Miteru::Feeds::PhishStats).to receive_message_chain(:new, :urls).and_return([url])
    end

    it "returns an Array without duplicated" do
      results = subject.new.suspicious_urls
      expect(results).to be_an(Array)
      expect(results.length).to eq(1)
    end
  end
end
