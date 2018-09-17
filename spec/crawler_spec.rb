
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
  describe "#has_kit?" do
    context "when giving a url which contains a phishint kit" do
      before do
        path = File.expand_path("./fixtures/index.html", __dir__)
        data = File.read(path)

        allow_any_instance_of(Miteru::Crawler).to receive(:get).and_return(data)
      end
      it "should return true" do
        expect(subject.has_kit?("http://localhost")).to eq(true)
      end
    end
  end
  context "when giving a url which doesn't contain a phishint kit" do
    before do
      allow_any_instance_of(Miteru::Crawler).to receive(:get).and_return("None")
    end
    it "should return false" do
      expect(subject.has_kit?("http://localhost")).to eq(false)
    end
  end
end

