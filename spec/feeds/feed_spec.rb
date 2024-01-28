# frozen_string_literal: true

RSpec.describe Miteru::Feeds::Base do
  subject(:feed) { described_class.new("http://127.0.0.1") }

  describe "#decomposed_urls" do
    context "with a URL without path" do
      before { allow(feed).to receive(:urls).and_return(["http://127.0.0.1"]) }

      it do
        expect(subject.decomposed_urls).to eq(["http://127.0.0.1"])
      end
    end

    context "with a URL has path" do
      before { allow(feed).to receive(:urls).and_return(["http://127.0.0.1/test/test/index.htm"]) }

      context "without directory traveling" do
        before { allow(Miteru.config).to receive(:directory_traveling).and_return(false) }

        it do
          expect(subject.decomposed_urls).to eq(["http://127.0.0.1"])
        end
      end

      context "with directory traveling" do
        before { allow(Miteru.config).to receive(:directory_traveling).and_return(true) }

        it do
          expect(subject.decomposed_urls).to eq(["http://127.0.0.1", "http://127.0.0.1/test", "http://127.0.0.1/test/test"])
        end
      end
    end
  end
end
