require "spec_helper"

describe MgeWholesale do
  it "has a version number" do
    expect(MgeWholesale::VERSION).not_to be nil
  end

  describe "::Configuration" do
    before do
      MgeWholesale.configure do |config|
        config.ftp_host       = "ftp.host.com"
        config.top_level_dir  = "Test"
        config.submission_dir = "toBHC"
        config.response_dir   = "fromBHC"
      end
    end

    it { expect(MgeWholesale.config.ftp_host).to eq("ftp.host.com") }
    it { expect(MgeWholesale.config.top_level_dir).to eq("Test") }
    it { expect(MgeWholesale.config.submission_dir).to eq("toBHC") }
    it { expect(MgeWholesale.config.response_dir).to eq("fromBHC") }

    describe '#full_submission_dir' do
      it { expect(MgeWholesale.config.full_submission_dir).to eq("Test/toBHC") }
    end

    describe '#full_response_dir' do
      it { expect(MgeWholesale.config.full_response_dir).to eq("Test/fromBHC") }
    end
  end
end
