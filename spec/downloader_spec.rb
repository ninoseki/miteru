# frozen_string_literal: true

RSpec.describe Miteru::Downloader do
  include_context "with fake HTTP server"
  include_context "with mocked logger"

  let!(:url) { "#{server.base_url}/has_kit" }
  let!(:kit) { Miteru::Kit.new("#{url}/test.zip", source: "dummy") }

  describe "#call" do
    before do
      kit.valid?
    end

    it do
      downloader = described_class.new(kit)
      destination = downloader.call
      expect(File.exist?(destination)).to eq(true)

      expect { downloader.call }.to raise_error(Miteru::UniquenessError)
    end
  end
end
