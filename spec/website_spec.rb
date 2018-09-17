# frozen_string_literal: true

RSpec.describe Miteru::Website, :vcr do
  subject { Miteru::Website }
  describe "#has_kit?" do
    context "when giving a url which contains a phishint kit" do
      before do
        path = File.expand_path("./fixtures/index.html", __dir__)
        data = File.read(path)

        allow_any_instance_of(Miteru::Website).to receive(:get).and_return(data)
      end
      it "should return true" do
        expect(subject.new("http://localhost").has_kit?).to eq(true)
      end
    end
  end
  context "when giving a url which doesn't contain a phishint kit" do
    before do
      allow_any_instance_of(Miteru::Website).to receive(:get).and_return("None")
    end
    it "should return false" do
      expect(subject.new("http://localhost").has_kit?).to eq(false)
    end
  end
end
