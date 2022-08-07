# frozen_string_literal: true

Website = Struct.new(:url, :kits, :message, keyword_init: true)

RSpec.describe Miteru::Notifiers::Slack do
  subject { described_class.new }

  describe "#notify" do
    let(:sio) { StringIO.new }

    let(:logger) do
      SemanticLogger.default_level = :info
      SemanticLogger.add_appender(io: sio, formatter: :color)
      SemanticLogger["Miteru"]
    end

    before do
      allow(Miteru).to receive(:logger).and_return(logger)
    end

    context "when not given SLACK setting via ENV" do
      let(:website) do
        Website.new(url: "http://test.com", kits: [], message: "test")
      end

      it "outputs a message to STDOUT" do
        subject.notify(website)

        # read logger output
        SemanticLogger.flush
        sio.rewind
        out = sio.read

        expect(out).to include("test.com")
      end
    end
  end
end
