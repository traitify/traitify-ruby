require "spec_helper"

describe Traitify::Client do
  before do
    Traitify.configure do |tom|
      tom.secret = "secret"
      tom.api_host = "https://example.com"
      tom.api_version = "v1"
      tom.deck_id = "deck-uuid"
    end
  end

  let(:client) { Traitify.new }

  describe "Analytics" do
    context do 
      let(:analytics) { client.assessment_analytics(10) }

      before(:each) do
        stub_it(:get, "/analytics/decks/10/assessments?locale_key=en-us", "assessment_analytics")
      end

      it "returns an array of decks" do
        expect(analytics.first.id).to eq("assessment-analytics-uuid")
      end
    end

    context do 
      let(:analytics) { client.trait_analytics(10) }

      before(:each) do
        stub_it(:get, "/analytics/decks/10/personality_traits?locale_key=en-us", "trait_analytics")
      end

      it "returns an array of decks" do
        expect(analytics.first.id).to eq("trait-analytics-uuid")
      end
    end

    context do 
      let(:analytics) { client.type_analytics(10) }

      before(:each) do
        stub_it(:get, "/analytics/decks/10/personality_types?locale_key=en-us", "type_analytics")
      end

      it "returns an array of decks" do
        expect(analytics.first.id).to eq("type-analytics-uuid")
      end
    end
  end
end
