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

  describe ".decks" do
    context "without a user" do
      let(:decks){ client.decks.data }

      before(:each) do
        stub_it(:get, "/decks?locale_key=en-us", "decks")
      end

      it "returns an array of decks" do
        expect(decks.first.id).to eq("deck-uuid")
      end
    end
  end
end
