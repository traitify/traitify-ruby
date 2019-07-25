require "spec_helper"

describe Traitify::Client do
  let(:tom){ Traitify.new }

  context "config setters" do
    before do
      Traitify.configure do |tom|
        tom.secret_key = "secret"
        tom.host = "https://example.com"
        tom.version = "v1"
        tom.deck_id = "deck-uuid"
      end
    end

    it "assigns secret" do
      expect(tom.secret_key).to eq("secret")
    end

    it "assigns api_host" do
      expect(tom.host).to eq("https://example.com")
    end

    it "assigns api_version" do
      expect(tom.version).to eq("v1")
    end
  end
end
