# frozen_string_literal: true

RSpec.describe Miteru::Feeds::UrlScan, :vcr do
  subject { described_class }

  let(:sio) { StringIO.new }

  let(:logger) do
    SemanticLogger.default_level = :info
    SemanticLogger.add_appender(io: sio, formatter: :color)
    SemanticLogger["Miteru"]
  end

  context "without 'size' option" do
    it do
      results = subject.new.urls
      expect(results).to be_an(Array)
      expect(results.length).to eq(100)
    end
  end

  context "with 'size' option" do
    context "when size <= 10,000" do
      it "returns an array with the specified size" do
        results = subject.new(10_000).urls
        expect(results).to be_an(Array)
        expect(results.length).to eq(10_000)
      end
    end

    context "when size > 10,000" do
      it do
        expect { subject.new(10_001).urls }.to raise_error(ArgumentError)
      end
    end

    context "when an error is raised" do
      before do
        allow(UrlScan::API).to receive(:new).and_raise(UrlScan::ResponseError, "test")
        allow(Miteru).to receive(:logger).and_return(logger)
      end

      it do
        subject.new.urls

        # read logger output
        SemanticLogger.flush
        sio.rewind
        out = sio.read

        expect(out).to include("Failed to load urlscan.io feed (test)\n")
      end
    end
  end
end
