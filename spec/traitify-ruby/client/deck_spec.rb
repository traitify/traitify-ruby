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

  let(:tom) { Traitify.new }

  describe ".create_assessment" do
    context "without a user" do
      let(:decks) { tom.decks }

      before(:each) do
        stub_it(:get, "/decks?locale_key=us-english", "decks")
      end

      it "returns an array of decks" do
        expect(decks.first.id).to eq("deck-uuid")
      end
    end
  end
end
