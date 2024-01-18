require "spec_helper"

describe Traitify::Client do
  let(:traitify){ Traitify.new }

  context "config setters" do
    before do
      Traitify.configure do |client|
        client.secret_key = "secret"
        client.host = "https://example.com"
        client.version = "v1"
        client.deck_id = "deck-uuid"
        client.logger = Logger.new("/dev/null")
      end
    end

    it "assigns host" do
      expect(traitify.host).to eq("https://example.com")
    end

    it "assigns secret" do
      expect(traitify.secret_key).to eq("secret")
    end

    it "assigns version" do
      expect(traitify.version).to eq("v1")
    end
  end
end
