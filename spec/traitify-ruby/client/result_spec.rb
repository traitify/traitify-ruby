require "spec_helper"

describe Traitify::Client do
  before do
    Traitify.configure do |client|
      client.secret = "secret"
      client.api_host = "https://example.com"
      client.api_version = "v1"
    end
  end

  let(:client) { Traitify }

  describe ".find_results" do
    context "without an image pack" do
      let(:result) { client.assessments("assessment-uuid").personality_types }

      before(:each) do
        stub_it(:get, "/assessments/assessment-uuid/personality_types?locale_key=en-us", "result")
      end

      it "returns a result" do
        expect(result.personality_types.first.personality_type.name).to eq("Analyzer")
      end
    end

    context "with an image pack" do
      context "set in the configurations" do
        let(:client) do
          Traitify
        end
        let(:result) do
          Traitify.configure do |c|
            c.image_pack = "full-color"
          end 
          res = Traitify.assessments("assessment-uuid").personality_types
          Traitify.configure do |c|
            c.image_pack = nil
          end 
          res
        end

        before(:each) do
          stub_it(:get, "/assessments/assessment-uuid/personality_types?image_pack=full-color&locale_key=en-us", "result")
        end

        it "returns a result" do
          expect(result.personality_blend.personality_type_1.badge.image_large).to eq("https://traitify-api.s3.amazonaws.com/traitify-api/badges/analayzer/full-color/large")
        end
      end

      context "set in the call" do
        let(:result) { client.assessments("assessment-uuid").personality_types({image_pack: "full-color"}) }

        before(:each) do
          stub_it(:get, "/assessments/assessment-uuid/personality_types?image_pack=full-color&locale_key=en-us", "result")
        end

        it "returns a result" do
          expect(result.personality_blend.personality_type_1.badge.image_large).to eq("https://traitify-api.s3.amazonaws.com/traitify-api/badges/analayzer/full-color/large")
        end
      end
    end
  end

  describe ".assessment_personality_type" do
    context "with a personality type" do
      let(:personality_traits) { client.assessments("assessment-uuid").personality_types("personality-type-uuid").personality_traits }

      before(:each) do
        stub_it(:get, "/assessments/assessment-uuid/personality_types/personality-type-uuid/personality_traits?locale_key=en-us", "personality_traits")
      end

      it "returns a result" do
        expect(personality_traits.first.personality_trait.name).to eq("Imaginative")
      end
    end

    context "without a personality type" do
      let(:personality_traits) { client.assessments("assessment-uuid").personality_traits }

      before(:each) do
        stub_it(:get, "/assessments/assessment-uuid/personality_traits?locale_key=en-us", "personality_traits")
      end

      it "returns a result" do
        expect(personality_traits.first.personality_trait.name).to eq("Imaginative")
      end
    end
  end

  describe ".career_matches" do
    let(:careers) { client.assessments("assessment-uuid").matches.careers }

    before(:each) do
      stub_it(:get, "/assessments/assessment-uuid/matches/careers?number_of_matches=10&locale_key=en-us", "careers")
    end

    it "returns a result" do
      expect(careers.first.title).to eq("Career Title")
      expect(careers.first.majors.first.title).to eq("Major Title")
    end
  end
end
