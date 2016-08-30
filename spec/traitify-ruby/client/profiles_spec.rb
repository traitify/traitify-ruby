require "spec_helper"

describe Traitify::Client do
  before do
    Traitify.configure do |c|
      c.secret = "secret"
      c.api_host = "https://example.com"
      c.api_version = "v1"
      c.deck_id = "deck-uuid"
    end
  end

  let(:client) { Traitify.new }

  describe ".profiles" do
    let(:profiles) { client.profiles }

    before(:each) do
      stub_it(:get, "/profiles?locale_key=en-us", "profiles")
    end

    it "returns an array of decks" do
      expect(profiles.first.id).to eq("profile-uuid")
    end
  end

  describe ".profile" do
    let(:profile) { client.profile(:uuid) }

    before(:each) do
      stub_it(:get, "/profiles/uuid?locale_key=en-us", "profile")
    end

    it "returns an array of decks" do
      expect(profile.id).to eq("profile-uuid")
    end
  end

  describe ".create_profile" do
    let(:profile) { client.create_profile({first_name: "Carson"}) }

    before(:each) do
      body = {
        first_name: "Carson",
        locale_key: "en-us"
      }
      stub_it(:post, "/profiles", {body: body}, "profile")
    end

    it "returns an array of decks" do
      expect(profile.id).to eq("profile-uuid")
    end
  end
end
