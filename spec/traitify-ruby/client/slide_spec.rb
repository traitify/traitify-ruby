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

    it "returns each slide's uuid" do
      expect(slides.first.id).to eq("slide-uuid")
    end
  end

  describe ".update_slides" do
    let(:slides) { tom.find_slides("assessment-uuid") }
    let(:slides_complete) { tom.update_slides("assessment-uuid", slides) }

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
    let(:slides) { tom.find_slides("assessment-uuid") }
    let(:slide) { tom.update_slide(
      assessment_id: "assessment-uuid",
      slide_id:      slides.first.id,
      response:      0,
      time_taken:    1000
    )}

    before(:each) do
      stub_it(:get, "/assessments/assessment-uuid/slides", "slides")
      stub_it(:put, "/assessments/assessment-uuid/slides/slide-uuid", "slide")
    end

    it "returns a slide" do
      expect(slide.response).to eq(true)
    end
  end
end
