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

  describe "#new" do
    it "sets options" do
      result = Traitify::Client.new

      expect(result.deck_id).to eq("deck-uuid")
      expect(result.host).to eq("https://example.com")
      expect(result.secret_key).to eq("secret")
      expect(result.version).to eq("v1")
    end

    it "merges options" do
      result = Traitify::Client.new(version: "v2")

      expect(result.deck_id).to eq("deck-uuid")
      expect(result.host).to eq("https://example.com")
      expect(result.secret_key).to eq("secret")
      expect(result.version).to eq("v2")
    end
  end

  describe "#to_hash" do
    it "returns state" do
      result = Traitify::Client.new(version: "v2")
      result = result.profiles(:profile_id).set(params: {foo: :bar}, verb: :post)

      expect(result.to_hash.symbolize_keys).to match(
        deck_id: "deck-uuid",
        host: "https://example.com",
        locale_key: "en-us",
        params: {foo: :bar},
        path: "/profiles/profile_id",
        secret_key: "secret",
        type: :profiles,
        verb: :post,
        version: "v2"
      )
    end
  end
end
