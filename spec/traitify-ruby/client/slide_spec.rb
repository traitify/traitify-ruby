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

  describe ".find_slides" do
    let(:slides) { tom.find_slides("assessment-uuid") }

    before(:each) do
      stub_it(:get, "/assessments/assessment-uuid/slides", "slides")
    end

    it "returns an assessment's slides" do
      expect(slides.assessment_id).to eq("assessment-uuid")
    end

    it "returns slides' assessment uuid" do
      expect(slides.assessment_id).to eq("assessment-uuid")
    end
  end

  describe ".update_slides" do
    let(:slides) { tom.find_slides("assessment-uuid") }
    let(:slides_complete) { tom.update_slides(slides) }

    before(:each) do
      stub_it(:get, "/assessments/assessment-uuid/slides", "slides")
      stub_it(:put, "/assessments/assessment-uuid/slides", "slides_complete")
      slides.each do |slide|
        slide.response = 0
        slide.time_taken = 1000
      end
    end

    it "returns an assessment" do
      expect(slides_complete.first.response).to eq(true)
    end
  end

  describe ".update_slide" do
    context "with arguments" do
      let(:slides) { tom.find_slides("assessment-uuid") }
      let(:slide) { slides.first }
      let(:slide_complete) { tom.update_slide(slides.assessment_id, slide) }

      before(:each) do
        stub_it(:get, "/assessments/assessment-uuid/slides", "slides")
        stub_it(:put, "/assessments/assessment-uuid/slides/dd0f359c-afbd-4be5-8f96-62d8c2d18ae9", "slide")

        slide.response = 0
        slide.time_taken = 1000
      end

      it "returns a slide" do
        expect(slide_complete.response).to eq(true)
      end
    end

    context "with a hash" do
      let(:slides) { tom.find_slides("assessment-uuid") }
      let(:slide) { tom.update_slide(
        assessment_id: slides.assessment_id,
        slide_id:      slides.first.id,
        response:      0,
        time_taken:    1000
      )}

      before(:each) do
        stub_it(:get, "/assessments/assessment-uuid/slides", "slides")
        stub_it(:put, "/assessments/assessment-uuid/slides/dd0f359c-afbd-4be5-8f96-62d8c2d18ae9", "slide")
      end

      it "returns a slide" do
        expect(slide.response).to eq(true)
      end
    end
  end
end
