require "spec_helper"

describe Traitify::Client do
  before do
    Traitify.configure do |client|
      client.secret_key = "secret"
      client.host = "https://example.com"
      client.version = "v1"
      client.deck_id = "deck-uuid"
    end
  end

  let(:client){ Traitify.new }

  describe ".create_assessment" do
    context "without a user" do
      let(:assessment){ client.assessments.create.data }

      before(:each) do
        stub_it(:post, "/assessments", "assessment")
      end

      it "returns an assessment" do
        expect(assessment.deck_id).to eq(client.deck_id)
      end
    end

    context "with a user" do
      let(:assessment){ client.assessments.create(user_id: "clients-uuid").data }

      before(:each) do
        stub_it(:post, "/assessments", "assessment")
      end

      it "returns an assessment" do
        expect(assessment.user_id).to eq("toms-uuid")
      end
    end

    context "with a deck" do
      let(:assessment){ client.assessments.create(deck_id: "other-deck-uuid").data }

      before(:each) do
        stub_it(:post, "/assessments", "assessment")
      end

      it "returns an assessment" do
        expect(assessment.id).to eq("assessment-uuid")
      end
    end
  end

  describe ".find_assessment" do
    let(:assessment){ client.assessments("assessment-uuid").data }

    before(:each) do
      stub_it(:get, "/assessments/assessment-uuid?locale_key=en-us", "assessment")
    end

    it "returns an assessment" do
      expect(assessment.id).to eq("assessment-uuid")
    end
  end

  describe ".assessment_with_results" do
    let(:result){ client.assessments("assessment-uuid").find(data: [:traits, :types, :blend]).data }

    before(:each) do
      stub_it(
        :get,
        "/assessments/assessment-uuid?data=traits,types,blend&locale_key=en-us",
        "assessment_with_results"
      )
    end

    it "returns an assessment with results" do
      expect(result.personality_types.first.personality_type.name).to eq("Analyzer")
      expect(result.personality_traits.first.personality_trait.name).to eq("Imaginative")
    end
  end
end
