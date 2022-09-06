require "spec_helper"

describe Traitify::Client do
  before do
    Traitify.configure do |client|
      client.secret_key = "secret"
      client.host = "https://example.com"
      client.version = "v1"
      client.deck_id = "deck-uuid"
      client.logger = Logger.new("/dev/null")
    end
  end

  let(:client){ Traitify.new }

  describe ".profiles" do
    let(:profiles){ client.profiles.data }

    before(:each) do
      stub_it(:get, "/profiles?locale_key=en-us", "profiles")
    end

    it "returns an array of decks" do
      expect(profiles.first.id).to eq("profile-uuid")
    end
  end

  describe ".profile" do
    let(:profile){ client.profiles(:uuid).data }

    before(:each) do
      stub_it(:get, "/profiles/uuid?locale_key=en-us", "profile")
    end

    it "returns an array of decks" do
      expect(profile.id).to eq("profile-uuid")
    end
  end

  describe ".create_profile" do
    let(:profile){ client.profiles.create({first_name: "Carson"}).data }

    before(:each) do
      stub_it(:post, "/profiles", "profile", body: {
        first_name: "Carson",
        locale_key: "en-us"
      })
    end

    it "returns an array of decks" do
      expect(profile.id).to eq("profile-uuid")
    end
  end

  describe ".matches.profiles(...)" do
    let(:match){ client.profiles(:uuid).matches.profiles(:profile_id).data }

    before(:each) do
      stub_it(:get, "/profiles/uuid/matches/profiles/profile_id?locale_key=en-us", "profile")
    end

    it "returns an array of decks" do
      expect(match.id).to eq("profile-uuid")
    end
  end
end
