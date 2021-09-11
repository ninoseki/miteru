class Test < Miteru::Feeds::Feed; end

RSpec.describe Miteru::Feeds::Feed do
  subject { Test.new }

  describe "#breakdown" do
    context "when given an url without path" do
      it do
        results = subject.breakdown("http://test.com", false)
        expect(results).to be_an(Array)
        expect(results.length).to eq(1)
      end
    end

    context "when given an url with path" do
      context "when disabling directory_traveling" do
        it do
          results = subject.breakdown("http://test.com/test/test/index.html", false)
          expect(results).to be_an(Array)
          expect(results.length).to eq(1)
          expect(results.first).to eq("http://test.com")
        end
      end

      context "when enabling directory_traveling" do
        it do
          results = subject.breakdown("http://test.com/test/test/index.html", true)
          expect(results).to eq(["http://test.com", "http://test.com/test", "http://test.com/test/test"])
        end
      end
    end
  end
end
