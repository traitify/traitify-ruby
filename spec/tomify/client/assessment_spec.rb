require "spec_helper"

describe Tomify::Client do
  before do
    Tomify.configure do |tom|
      tom.secret = "secret"
      tom.api_host = "https://example.com"
      tom.api_version = "v1"
      tom.deck_id = "deck-uuid"
    end
  end

  let(:tom) { Tomify.new }

  describe ".create_assessment" do
    context "without a user" do
      let(:assessment) { tom.create_assessment }

      before(:each) do
        stub_it(:post, "/assessments", "assessment")
      end

      it "returns an assessment" do
        expect(assessment.deck_id).to eq(tom.deck_id)
      end
    end

    context "with a user" do
      let(:assessment) { tom.create_assessment(user_id: "toms-uuid") }

      before(:each) do
        stub_it(:post, "/assessments", "assessment")
      end

      it "returns an assessment" do
        expect(assessment.user_id).to eq("toms-uuid")
      end
    end

    context "with a deck" do
      let(:assessment) { tom.create_assessment(deck_id: "other-deck-uuid") }

      before(:each) do
        stub_it(:post, "/assessments", "assessment")
      end

      it "returns an assessment" do
        expect(assessment.id).to eq("assessment-uuid")
      end
    end
  end

  describe ".find_assessment" do
    let(:assessment) { tom.find_assessment("assessment-uuid") }

    before(:each) do
      stub_it(:get, "/assessments/assessment-uuid", "assessment")
    end

    it "returns an assessment" do
      expect(assessment.id).to eq("assessment-uuid")
    end
  end
end
