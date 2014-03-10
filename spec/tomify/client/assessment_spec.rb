require "spec_helper"

describe Tomify::Client do
  before do
    Tomify.configure do |tom|
      tom.api_host = "example.com"
      tom.api_version = "v1"
      tom.deck_id = "deck-uuid"
    end
  end

  let(:tom) { Tomify.new }

  describe ".create_assessment" do
    context "without a user" do
      let(:assessment) { tom.create_assessment }

      before(:each) do
        stub_it(:put, "/assessments?deck_id=deck-uuid", "assessment")
      end

      it "returns an assessment" do
        expect(assessment.slides.first.order).to eq(1)
      end
    end

    context "with a user" do
      let(:assessment) { tom.create_assessment(user_id: "toms-uuid") }

      before(:each) do
        stub_it(:put, "/assessments?deck_id=deck-uuid&user_id=toms-uuid", "assessment")
      end

      it "returns an assessment" do
        expect(assessment.user_id).to eq("toms-uuid")
      end
    end

    context "with a deck" do
      let(:assessment) { tom.create_assessment(deck_id: "other-deck-uuid") }

      before(:each) do
        stub_it(:put, "/assessments?deck_id=other-deck-uuid", "assessment")
      end

      it "returns an assessment" do
        expect(assessment.slides.first.order).to eq(1)
      end
    end
  end

  describe ".find_assessment" do
    let(:assessment) { tom.find_assessment("assessment-uuid") }

    before(:each) do
      stub_it(:get, "/assessments/assessment-uuid", "assessment")
    end

    it "returns an assessment" do
      expect(assessment.slides.first.order).to eq(1)
    end
  end

  describe ".update_slides" do
    let(:assessment) { tom.find_assessment("assessment-uuid") }
    let(:assessment_complete) { tom.update_slides(assessment) }

    before(:each) do
      stub_it(:get, "/assessments/assessment-uuid", "assessment")
      stub_it(:put, "/assessments/assessment-uuid/slides?slides%5Bid%5D=00cccad0-b22b-4515-bebe-cec8c16c3c41&slides%5Bimage_url%5D=http://images.woofound.com/slides/1234583749081234.jpg&slides%5Border%5D=4&slides%5Bresponse%5D=0&slides%5Btime_taken%5D=600", "assessment_complete")
      assessment.slides.each do |slide|
        slide.response = 0
        slide.time_taken = 600
      end
    end

    it "returns an assessment" do
      expect(assessment_complete.slides.first.response).to eq(0)
    end
  end

  describe ".update_slide" do
    context "with arguments" do
      let(:assessment) { tom.find_assessment("assessment-uuid") }
      let(:slide) { assessment.slides.first }
      let(:slide_complete) { tom.update_slide(assessment.id, slide) }

      before(:each) do
        stub_it(:get, "/assessments/assessment-uuid", "assessment")
        stub_it(:put, "/assessments/assessment-uuid/slides/dd0f359c-afbd-4be5-8f96-62d8c2d18ae9?response=0&time_taken=600", "slide")

        slide.response = 0
        slide.time_taken = 600
      end

      it "returns a slide" do
        expect(slide_complete.response).to eq(0)
      end
    end

    context "with a hash" do
      let(:assessment) { tom.find_assessment("assessment-uuid") }
      let(:slide) { tom.update_slide(
        assessment_id: assessment.id,
        slide_id:      assessment.slides.first.id,
        response:      0,
        time_taken:    600
      )}

      before(:each) do
        stub_it(:get, "/assessments/assessment-uuid", "assessment")
        stub_it(:put, "/assessments/assessment-uuid/slides/dd0f359c-afbd-4be5-8f96-62d8c2d18ae9?response=0&time_taken=600", "slide")
      end

      it "returns a slide" do
        expect(slide.response).to eq(0)
      end
    end
  end
end
