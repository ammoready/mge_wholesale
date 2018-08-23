require "spec_helper"

describe MgeWholesale do
  it "has a version number" do
    expect(MgeWholesale::VERSION).not_to be nil
  end

  describe "::Configuration" do
    before do
      MgeWholesale.configure do |config|
        config.ftp_host      = "ftp.host.com"
        config.top_level_dir = "Test"
      end
    end

    it { expect(MgeWholesale.config.ftp_host).to eq("ftp.host.com") }
  end
end
