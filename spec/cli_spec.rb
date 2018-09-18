
RSpec.describe Miteru::CLI do
  include_context "http_server"
  include_context "download_zip_files"

  subject { Miteru::CLI.new }
  describe "#download_zip_files" do
    it "should not raise any error" do
      url = "http://#{host}:#{port}/has_kit"
      zip_files = ["#{url}/test.zip"]
      expect(File.exist?("#{base_dir}/test.zip")).to eq(false)
      subject.download_zip_files(url, zip_files, @path)
      expect(File.exist?("#{base_dir}/test.zip")).to eq(true)
    end
  end
end
