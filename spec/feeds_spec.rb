# frozen_string_literal: true

RSpec.describe Miteru::Feeds do
  subject { Miteru::Feeds }

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

  describe "#suspicious_urls" do
    before do
      allow_any_instance_of(Miteru::Feeds::UrlScan).to receive(:urls).and_return(["https://test.com"])
      allow_any_instance_of(Miteru::Feeds::Ayashige).to receive(:urls).and_return(["https://test.com"])
    end
    it "should return an Array without duplicated" do
      results = subject.new.suspicious_urls
      expect(results).to be_an(Array)
      expect(results.length).to eq(1)
    end
  end
end
