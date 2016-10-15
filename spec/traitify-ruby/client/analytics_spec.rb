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

  describe ".analytics" do
    context do
      let(:assessments) { client.analytics.decks("deck-id").assessments.all }

      before(:each) do
        stub_it(:get, "/analytics/decks/deck-id/assessments?locale_key=en-us", "assessment")
      end

      it "returns assessments" do
        expect(assessments.deck_id).to eq(client.deck_id)
      end
    end

    context do
      let(:personality_traits) { client.analytics.decks("deck-id").personality_traits.all }

      before(:each) do
        stub_it(:get, "/analytics/decks/deck-id/personality_traits?locale_key=en-us", "assessment")
      end

      it "returns an personality_traits" do
        expect(personality_traits.deck_id).to eq(client.deck_id)
      end
    end

    context do
      let(:personality_types) { client.analytics.decks("deck-id").personality_types.all }

      before(:each) do
        stub_it(:get, "/analytics/decks/deck-id/personality_types?locale_key=en-us", "assessment")
      end

      it "returns an personality_types" do
        expect(personality_types.deck_id).to eq(client.deck_id)
      end
    end
  end
end
