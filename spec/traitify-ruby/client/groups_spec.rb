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

  let(:client) { Traitify }

  describe ".groups" do
    let(:groups) { client.groups }

    before(:each) do
      stub_it(:get, "/groups?locale_key=en-us", "groups")
    end

    it "returns an array of decks" do
      expect(groups.first.id).to eq("group-uuid")
    end
  end

  describe ".group(id)" do
    let(:group) { client.groups(:uuid) }

    before(:each) do
      stub_it(:get, "/groups/uuid?locale_key=en-us", "group")
    end

    it "returns an array of decks" do
      expect(group.id).to eq("group-uuid")
    end
  end

  describe ".group.create(...)" do
    let(:group) { client.groups.create({name: "TESTING"}) }

    before(:each) do
      stub_it(:post, "/groups", {body: {name: "TESTING", locale_key: "en-us"}}, "group")
    end

    it "returns an array of decks" do
      expect(group.id).to eq("group-uuid")
    end
  end
end
