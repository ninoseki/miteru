# frozen_string_literal: true

RSpec.describe Miteru::Configuration do
  context "when no input given" do
    it do
      expect(Miteru.configuration).to be_a(described_class)
    end

    it do
      expect(Miteru.configuration.threads).to eq(Parallel.processor_count)
    end
  end

  context "when given an input" do
    it do
      Miteru.configure do |config|
        config.auto_download = false
      end
      expect(Miteru.configuration.auto_download).to be_falsey
    end
  end

  describe "#auto_download?" do
    it do
      expect(Miteru.configuration).not_to be_auto_download
    end
  end

  describe "#ayashige?" do
    it do
      expect(Miteru.configuration).not_to be_ayashige
    end
  end

  describe "#directory_traveling?" do
    it do
      expect(Miteru.configuration).not_to be_directory_traveling
    end
  end

  describe "#post_to_slack?" do
    it do
      expect(Miteru.configuration).not_to be_post_to_slack
    end
  end

  describe "#verbose?" do
    it do
      expect(Miteru.configuration).not_to be_verbose
    end
  end
end
