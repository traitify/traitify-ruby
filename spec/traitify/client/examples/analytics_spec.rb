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

  describe ".analytics" do
    context ".aggregate" do
      let(:data){
        client.analytics.decks("big-five")
          .aggregate(stats: [:created_count, :started_count, :completed_count]).data
      }

      before(:each) do
        query = "locale_key=en-us&stats=created_count&stats=started_count&stats=completed_count"
        stub_it(:get, "/analytics/decks/big-five/aggregate?#{query}", "aggregate")
      end

      it "returns assessments" do
        expect(data.assessments.started_count).to eq(10)
      end
    end

    context ".assessments" do
      let(:assessments){ client.analytics.decks("deck-id").assessments.data }

      before(:each) do
        stub_it(:get, "/analytics/decks/deck-id/assessments?locale_key=en-us", "assessment")
      end

      it "returns assessments" do
        expect(assessments.deck_id).to eq(client.deck_id)
      end
    end

    context ".personality_traits" do
      let(:personality_traits){ client.analytics.decks("deck-id").personality_traits.data }

      before(:each) do
        stub_it(:get, "/analytics/decks/deck-id/personality_traits?locale_key=en-us", "assessment")
      end

      it "returns an personality_traits" do
        expect(personality_traits.deck_id).to eq(client.deck_id)
      end
    end

    context ".personality_types" do
      let(:personality_types){ client.analytics.decks("deck-id").personality_types.data }

      before(:each) do
        stub_it(:get, "/analytics/decks/deck-id/personality_types?locale_key=en-us", "assessment")
      end

      it "returns an personality_types" do
        expect(personality_types.deck_id).to eq(client.deck_id)
      end
    end
  end
end
