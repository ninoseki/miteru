# frozen_string_literal: true

require "fileutils"

RSpec.shared_context "download_kits" do
  let(:base_dir) { File.expand_path("../../../tmp", __dir__) }

  before do
    FileUtils.mkdir_p base_dir
  end

  after do
    FileUtils.remove_dir(base_dir) if Dir.exist?(base_dir)
  end
end
