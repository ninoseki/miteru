# frozen_string_literal: true

RSpec.describe Miteru::CLI do
  subject { described_class.new }

  describe "#execute" do
    before do
      allow(Miteru::Feeds).to receive_message_chain(:new, :suspicious_urls).and_return(["http://#{host}:#{port}/has_kit"])
    end

    it "does not raise any error" do
      capture(:stdout) { described_class.start %w[execute] }
    end
  end

  describe ".exit_on_failure?" do
    it do
      expect(described_class.exit_on_failure?).to eq(true)
    end
  end
end
