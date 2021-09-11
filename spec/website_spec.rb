# frozen_string_literal: true

RSpec.describe Miteru::Website do
  include_context "http_server"

  let(:website_has_kit) { described_class.new("http://#{host}:#{port}/has_kit", "dummy") }
  let(:website_no_kit) { described_class.new("http://#{host}:#{port}/no_kit", "dummy") }

  describe "#title" do
    it do
      expect(website_has_kit.title).to be_a(String)
    end
  end

  describe "#kits" do
    it do
      expect(website_has_kit.kits).to be_an(Array)
    end

    it do
      expect(website_has_kit.kits.length).to eq(1)
    end
  end

  describe "#links" do
    it do
      expect(website_has_kit.links).to be_an(Array)
    end
  end

  context "when giving a url which contains a phishing kit" do
    describe "#has_kits?" do
      it do
        expect(website_has_kit.has_kits?).to be(true)
      end
    end

    describe "#message" do
      it do
        expect(website_has_kit.message).to start_with("it might contain a phishing kit")
      end
    end
  end

  context "when giving a url which doesn't contain a phishing kit" do
    describe "#has_kits?" do
      it do
        expect(website_no_kit.has_kits?).to be(false)
      end
    end

    describe "#message" do
      it do
        expect(website_no_kit.message).to eq("it doesn't contain a phishing kit.")
      end
    end
  end
end
