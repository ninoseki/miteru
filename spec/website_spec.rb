# frozen_string_literal: true

RSpec.describe Miteru::Website do
  include_context "with fake HTTP server"

  let!(:url) { "#{server.base_url}/has_kit" }

  subject(:website) { described_class.new(url, source: "dummy") }

  describe "#title" do
    it do
      expect(website.title).to be_a(String)
    end
  end

  describe "#kits" do
    it do
      expect(website.kits.length).to eq(1)
    end
  end

  describe "#links" do
    it do
      expect(website.links).to be_an(Array)
    end
  end

  describe "#kits?" do
    it do
      expect(website.kits?).to be(true)
    end
  end

  describe "#info" do
    it do
      expect(website.info).to be_a(String)
    end
  end
end
