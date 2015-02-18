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

  describe ".careers" do
    context "without params" do
      let(:careers) { tom.careers }

      before(:each) do
        stub_it(:get, "/careers", "careers")
      end

      it "returns careers" do
        expect(careers.first.title).to eq("Career Title")
      end
    end

    context "with params" do
      let(:careers) { tom.careers(page: 1, careers_per_page: 50) }

      before(:each) do
        stub_it(:get, "/careers?careers_per_page=50&page=1", "careers")
      end

      it "returns careers" do
        expect(careers.first.title).to eq("Career Title")
      end
    end
  end

  describe ".career" do
    let(:career) { tom.career("career-id") }

    before(:each) do
      stub_it(:get, "/careers/career-id", "career")
    end

    it "returns career" do
      expect(career.title).to eq("Career Title")
    end
  end
end
