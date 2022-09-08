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

  describe ".careers" do
    context "without params" do
      let(:careers){ client.careers.data }

      before(:each) do
        stub_it(:get, "/careers?locale_key=en-us", "careers")
      end

      it "returns careers" do
        expect(careers.first.title).to eq("Career Title")
      end
    end

    context "with params" do
      let(:careers){ client.careers(page: 1, careers_per_page: 50).data }

      before(:each) do
        stub_it(:get, "/careers?careers_per_page=50&page=1&locale_key=en-us", "careers")
      end

      it "returns careers" do
        expect(careers.first.title).to eq("Career Title")
      end
    end
  end

  describe ".career" do
    let(:career){ client.careers("career-id").data }

    before(:each) do
      stub_it(:get, "/careers/career-id?locale_key=en-us", "career")
    end

    it "returns career" do
      expect(career.title).to eq("Career Title")
    end
  end
end
