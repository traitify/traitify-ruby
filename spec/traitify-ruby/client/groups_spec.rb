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

  describe ".groups" do
    let(:groups) { client.groups }

    before(:each) do
      stub_it(:get, "/groups?locale_key=en-us", "groups")
    end

    it "returns an array of decks" do
      expect(groups.first.id).to eq("group-uuid")
    end
  end

  describe ".group" do
    let(:group) { client.group(:uuid) }

    before(:each) do
      stub_it(:get, "/groups/uuid?locale_key=en-us", "group")
    end

    it "returns an array of decks" do
      expect(group.id).to eq("group-uuid")
    end
  end

  describe ".create_group" do
    let(:group) { client.create_group({first_name: "Carson"}) }

    before(:each) do
      body = {
        first_name: "Carson",
        locale_key: "en-us"
      }
      stub_it(:post, "/groups", {body: body}, "group")
    end

    it "returns an array of decks" do
      expect(group.id).to eq("group-uuid")
    end
  end

  describe ".update_group" do
    let(:group) { client.update_group(10, {first_name: "Carson"}) }

    before(:each) do
      body = {
        first_name: "Carson",
        locale_key: "en-us"
      }
      stub_it(:put, "/groups/10", {body: body}, "group")
    end

    it "returns an array of decks" do
      expect(group.id).to eq("group-uuid")
    end
  end

  describe ".remove_group" do
    let(:group) { client.remove_group(10) }

    before(:each) do
      stub_it(:delete, "/groups/10", "blank")
    end

    it "returns an array of decks" do
      expect(group.id).to eq(nil)
    end
  end
end
