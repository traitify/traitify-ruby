require "spec_helper"

describe Traitify::Client do
  before do
    Traitify.configure do |tom|
      tom.secret_key = "secret"
      tom.host = "https://example.com"
      tom.version = "v1"
    end
  end

  let(:tom) { Traitify.new }

  describe ".majors" do
    context "without params" do
      let(:majors) { tom.majors }

      before(:each) do
        stub_it(:get, "/majors?locale_key=en-us", "majors")
      end

      it "returns majors" do
        expect(majors.first.title).to eq("Major Title")
      end
    end

    context "with params" do
      let(:majors) { tom.majors(page: 1, majors_per_page: 50) }

      before(:each) do
        stub_it(:get, "/majors?majors_per_page=50&page=1&locale_key=en-us", "majors")
      end

      it "returns majors" do
        expect(majors.first.title).to eq("Major Title")
      end
    end
  end

  describe ".major" do
    let(:major) { tom.major("major-id") }

    before(:each) do
      stub_it(:get, "/majors/major-id?locale_key=en-us", "major")
    end

    it "returns major" do
      expect(major.title).to eq("Major Title")
    end
  end
end
