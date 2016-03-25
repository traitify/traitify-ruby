require "spec_helper"

describe Traitify::Client do
  before do
    Traitify.configure do |tom|
      tom.secret = "secret"
      tom.api_host = "https://example.com"
      tom.api_version = "v1"
      tom.deck_id = "deck-uuid"
    end
  end

  let(:tom) { Traitify.new }

  describe ".locales" do
    let(:locales) { tom.locales }

    before(:each) do
      stub_it(:get, "/locales", "locales")
    end

    it "returns an array of locales" do
      expect(locales.first.country_code).to eq("US")
    end
  end

  describe ".locale" do
    let(:locale) { tom.locale("us-english") }

    before(:each) do
      stub_it(:get, "/locales/us-english", "locale")
    end

    it "returns a locale" do
      expect(locale.country_code).to eq("US")
    end
  end
end
