# frozen_string_literal: true

class DummyFeed < Miteru::Feeds::Base
  def initialize(base_url = "http://example.com")
    super(base_url)
  end

  def urls
    ["http://example.com"] * 10
  end
end

RSpec.describe Miteru::Orchestrator do
  include_context "with mocked logger"

  subject(:orchestrator) { described_class.new }

  before do
    allow(orchestrator).to receive(:feeds).and_return([DummyFeed.new] * 10)
  end

  describe "#websites" do
    it do
      expect(orchestrator.websites.map(&:url)).to eq(["http://example.com"])
    end
  end
end
