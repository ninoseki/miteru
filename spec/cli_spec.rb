# frozen_string_literal: true

RSpec.describe Miteru::CLI do
  subject { Miteru::CLI.new }

  describe "#execute" do
    before do
      allow(Miteru::Feeds).to receive_message_chain(:new, :suspicious_urls).and_return(["http://#{host}:#{port}/has_kit"])
    end

    it "should not raise any error" do
      capture(:stdout) { Miteru::CLI.start %w(execute) }
    end
  end
end
