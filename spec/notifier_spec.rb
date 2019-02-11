# frozen_string_literal: true

RSpec.describe Miteru::Notifier do
  subject { Miteru::Notifier.new }

  describe "#notify" do
    context "when not given SLACK setting via ENV" do
      it "should output a message to STDOUT" do
        out = capture(:stdout) {
          subject.notify("http://test.com", ["test.zip"])
        }
        expect(out).to include("test.com")
      end
    end
  end
end
