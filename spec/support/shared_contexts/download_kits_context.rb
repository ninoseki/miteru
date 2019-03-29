# frozen_string_literal: true

require "fileutils"

RSpec.shared_context "download_kits" do
  before do
    @path = File.expand_path("../../../tmp", __dir__)
    FileUtils.mkdir_p(@path)
  end

  after do
    FileUtils.remove_dir(@path) if Dir.exist?(@path)
  end

  let(:base_dir) { @path }
end
