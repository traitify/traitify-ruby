require "spec_helper"

describe Traitify::Client do
  before do
    Traitify.configure do |client|
      client.secret = "secret"
      client.api_host = "https://example.com"
      client.api_version = "v1"
      client.deck_id = "deck-uuid"
    end
  end

  let(:client) { Traitify }

  describe ".decks" do
    context "without a user" do
      let(:decks) { client.decks }

      before(:each) do
        stub_it(:get, "/decks?locale_key=en-us", "decks")
      end

      it "returns an array of decks" do
        expect(decks.first.id).to eq("deck-uuid")
      end
    end
  end
end
