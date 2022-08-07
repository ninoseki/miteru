# frozen_string_literal: true

Website = Struct.new(:url, :kits, :message, keyword_init: true)

RSpec.describe Miteru::Notifiers::Slack do
  subject { described_class.new }

  describe "#notify" do
    context "when not given SLACK setting via ENV" do
      let(:website) do
        Website.new(url: "http://test.com", kits: [], message: "test")
      end

      it "outputs a message to STDOUT" do
        out = capture(:stdout) { subject.notify(website) }
        expect(out).to include("test.com")
      end
    end
  end
end
