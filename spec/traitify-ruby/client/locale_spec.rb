require "spec_helper"

describe Traitify::Client do
  before do
    Traitify.configure do |client|
      client.secret_key = "secret"
      client.host = "https://example.com"
      client.version = "v1"
      client.deck_id = "deck-uuid"
    end
  end

  let(:client) { Traitify.new }

  describe ".locales" do
    let(:locales) { client.locales.data }

    before(:each) do
      stub_it(:get, "/locales", "locales")
    end

    it "returns an array of locales" do
      expect(locales.first.country_code).to eq("US")
    end
  end

  describe ".locale" do
    let(:locale) { client.locales("en-us").data }

    before(:each) do
      stub_it(:get, "/locales/en-us", "locale")
    end

    it "returns a locale" do
      expect(locale.country_code).to eq("US")
    end
  end
end
