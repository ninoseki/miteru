# frozen_string_literal: true

RSpec.describe Miteru::CLI::App do
  subject { described_class.new }

  describe ".exit_on_failure?" do
    it do
      expect(described_class.exit_on_failure?).to eq(true)
    end
  end
end
