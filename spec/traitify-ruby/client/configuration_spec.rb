require "spec_helper"

describe Traitify::Client do
  let(:tom) { Traitify.new }

  context "using old setters" do
    before do
      Traitify.configure do |tom|
        tom.secret = "secret"
        tom.api_host = "https://example.com"
        tom.api_version = "v1"
        tom.deck_id = "deck-uuid"
      end
    end

    it "assigns secret_key" do
      expect(tom.secret_key).to eq("secret")
    end

    it "assigns host" do
      expect(tom.host).to eq("https://example.com")
    end

    it "assigns version" do
      expect(tom.version).to eq("v1")
    end
  end

  context "using new setters" do
    before do
      Traitify.configure do |tom|
        tom.secret_key = "secret"
        tom.host = "https://example.com"
        tom.version = "v1"
        tom.deck_id = "deck-uuid"
      end
    end

    it "assigns secret" do
      expect(tom.secret).to eq("secret")
    end

    it "assigns api_host" do
      expect(tom.api_host).to eq("https://example.com")
    end

    it "assigns api_version" do
      expect(tom.api_version).to eq("v1")
    end
  end
end
