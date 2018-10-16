# frozen_string_literal: true

RSpec.describe Miteru::Website do
  include_context "http_server"

  subject { Miteru::Website }
  describe "#title" do
    it "should return a String" do
      expect(subject.new("http://#{host}:#{port}/has_kit").title).to be_a(String)
    end
  end
  describe "#compressed_files" do
    it "should return an Array" do
      compressed_files = subject.new("http://#{host}:#{port}/has_kit").compressed_files
      expect(compressed_files).to be_an(Array)
      expect(compressed_files.length).to eq(2)
    end
  end
  describe "#has_kit?" do
    context "when giving a url which contains a phishint kit" do
      it "should return true" do
        expect(subject.new("http://#{host}:#{port}/has_kit").has_kit?).to eq(true)
      end
    end
    context "when giving a url which doesn't contain a phishint kit" do
      it "should return false" do
        expect(subject.new("http://#{host}:#{port}/no_kit").has_kit?).to eq(false)
      end
    end
  end
end
