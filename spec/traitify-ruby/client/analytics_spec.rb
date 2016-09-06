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

  describe ".analytics" do
    context do
      let(:assessment) { client.analytics.decks("deck-id").assessments }

      before(:each) do
        stub_it(:get, "/analytics/decks/deck-id/assessments?locale_key=en-us", "assessment")
      end

      it "returns assessments" do
        expect(assessment.deck_id).to eq(client.deck_id)
      end
    end

    context do
      let(:personality_traits) { client.analytics.decks("deck-id").personality_traits }

      before(:each) do
        stub_it(:get, "/analytics/decks/deck-id/personality_traits?locale_key=en-us", "assessment")
      end

      it "returns an personality_traits" do
        expect(personality_traits.deck_id).to eq(client.deck_id)
      end
    end

    context do
      let(:personality_types) { client.analytics.decks("deck-id").personality_types }

      before(:each) do
        stub_it(:get, "/analytics/decks/deck-id/personality_types?locale_key=en-us", "assessment")
      end

      it "returns an personality_types" do
        expect(personality_types.deck_id).to eq(client.deck_id)
      end
    end
  end
end