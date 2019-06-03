# frozen_string_literal: true

RSpec.describe Miteru::Attachement do
  subject { described_class.new("https://github.com") }

  describe "#to_a" do
    it do
      array = subject.to_a
      array.each do |a|
        expect(a.key?(:text)).to eq(true)
        expect(a.key?(:actions)).to eq(true)
      end
    end
  end
end
