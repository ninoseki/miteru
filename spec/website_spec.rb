# frozen_string_literal: true

RSpec.describe Miteru::Website do
  include_context "http_server"
  subject { Miteru::Website }
  describe "#has_kit?" do
    context "when giving a url which contains a phishint kit" do
      it "should return true" do
        expect(subject.new("http://#{host}:#{port}/has_kit").has_kit?).to eq(true)
      end
    end
  end
  context "when giving a url which doesn't contain a phishint kit" do
    it "should return false" do
      expect(subject.new("http://#{host}:#{port}/no_kit").has_kit?).to eq(false)
    end
  end
end
