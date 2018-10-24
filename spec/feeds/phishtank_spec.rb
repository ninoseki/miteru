# frozen_string_literal: true

RSpec.describe Miteru::Feeds::PhishTank, :vcr do
  subject { Miteru::Feeds::PhishTank.new }

  it "should return an Array" do
    results = subject.urls
    expect(results).to be_an(Array)
  end

  context "when an error is raised" do
    before { allow_any_instance_of(Miteru::HTTPClient).to receive(:get).and_raise(Miteru::HTTPResponseError, "test") }
    it "should output a message" do
      message = capture(:stdout) { subject.urls }
      expect(message).to eq("Failed to load PhishTank feed (test)\n")
    end
  end
end
