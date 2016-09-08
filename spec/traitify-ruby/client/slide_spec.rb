require "spec_helper"

describe Traitify::Client do
  before do
    Traitify.configure do |client|
      client.secret = "secret"
      client.api_host = "https://example.com"
      client.api_version = "v1"
      client.deck_id = "deck-uuid"
    end
  end

  let(:client) { Traitify.new }

  describe ".find_slides" do
    let(:slides) { client.assessments("assessment-uuid").slides }

    before(:each) do
      stub_it(:get, "/assessments/assessment-uuid/slides?locale_key=en-us", "slides")
    end

    it "returns each slide's uuid" do
      expect(slides.first.id).to eq("slide-uuid")
    end
  end

  describe ".update_slides" do
    let(:slides) { client.assessments("assessment-uuid").slides.request }
    let(:slides_complete) { client.assessments("assessment-uuid").slides.update(slides) }

    before(:each) do
      stub_it(:get, "/assessments/assessment-uuid/slides?locale_key=en-us", "slides")
      body = slides.collect do |slide|
        slide.response = 0
        slide.time_taken = 1000
        slide
      end

      stub_it(:put, "/assessments/assessment-uuid/slides", {body: body}, "slides_complete")
    end

    it "returns an assessment" do
      expect(slides_complete.first.response).to eq(true)
    end
  end

  describe ".update_slide" do
    context "with hash" do
      let(:slides) { client.assessments("assessment-uuid").slides }
      let(:slide_params) do 
        {
          id:         slides.first.id,
          response:   true,
          time_taken: 1000
        }
      end
      let(:slide) { client.assessments("assessment-uuid").slides(slide_params[:id]).update(slide_params)}

      before(:each) do
        stub_it(:get, "/assessments/assessment-uuid/slides?locale_key=en-us", "slides")
        
        stub_it(:put, "/assessments/assessment-uuid/slides/slide-uuid", {body: slide_params.merge({locale_key: "en-us"})}, "slide")
      end

      it "returns a slide" do
        expect(slide.response).to eq(true)
      end
    end

    context "with slide" do
      let(:slides) { client.assessments("assessment-uuid").slides }
      let(:slide) { slides.first }

      before(:each) do
        stub_it(:get, "/assessments/assessment-uuid/slides?locale_key=en-us", "slides")
        stub_it(:put, "/assessments/assessment-uuid/slides/slide-uuid", "slide")

        slide.response = true
        slide.time_taken = 1000
        client.assessments("assessment-uuid").slides("slide-uuid").update(slide)
      end

      it "returns a slide" do
        expect(slide.response).to eq(true)
      end
    end
  end
end
