require "spec_helper"

describe Traitify::Client do
  before do
    Traitify.configure do |client|
      client.secret_key = "secret"
      client.host = "https://example.com"
      client.version = "v1"
      client.logger = Logger.new("/dev/null")
    end
  end

  let(:client){ Traitify.new }

  describe ".majors" do
    context "without params" do
      let(:majors){ client.majors.data }

      before(:each) do
        stub_it(:get, "/majors?locale_key=en-us", "majors")
      end

      it "returns majors" do
        expect(majors.first.title).to eq("Major Title")
      end
    end

    context "with params" do
      let(:majors){ client.majors(page: 1, majors_per_page: 50).data }

      before(:each) do
        stub_it(:get, "/majors?majors_per_page=50&page=1&locale_key=en-us", "majors")
      end

      it "returns majors" do
        expect(majors.first.title).to eq("Major Title")
      end
    end
  end

  describe ".major" do
    let(:major){ client.majors("major-id").data }

    before(:each) do
      stub_it(:get, "/majors/major-id?locale_key=en-us", "major")
    end

    it "returns major" do
      expect(major.title).to eq("Major Title")
    end
  end
end
