
RSpec.describe Miteru::CLI do
  include_context "http_server"
  include_context "download_zip_files"

  subject { Miteru::CLI.new }
  describe "#download_zip_files" do
    it "should download file(s)" do
      url = "http://#{host}:#{port}/has_kit"
      zip_files = ["test.zip"]

      expect(Dir.glob("#{base_dir}/*.zip").empty?).to be(true)
      subject.download_zip_files(url, zip_files, @path)
      expect(Dir.glob("#{base_dir}/*.zip").empty?).to be(false)
    end
  end
end
