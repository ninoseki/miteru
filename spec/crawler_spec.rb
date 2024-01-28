# frozen_string_literal: true

RSpec.describe Miteru::Crawler do
  include_context "with fake HTTP server"
  include_context "with mocked logger"

  subject(:crawler) { described_class.new }
  let!(:website) { Miteru::Website.new("#{server.base_url}/has_kit", source: "dummy") }

  describe "#call" do
    it do
      expect { crawler.call(website) }.not_to raise_error
    end
  end
end
