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
      stub_it(:get, "/assessments/assessment-uuid?locale_key=us-english", "assessment")
    end

    it "returns an assessment" do
      expect(assessment.id).to eq("assessment-uuid")
    end
  end

  describe ".assessment_with_results" do
    let(:result) { tom.assessment_with_results("assessment-uuid", nil, %w(traits types blend)) }

    before(:each) do
      stub_it(:get, "/assessments/assessment-uuid?data=traits,types,blend&locale_key=us-english", "assessment_with_results")
    end

    it "returns an assessment with results" do
      expect(result.personality_types.first.personality_type.name).to eq("Analyzer")
      expect(result.personality_traits.first.personality_trait.name).to eq("Imaginative")
    end
  end
end
