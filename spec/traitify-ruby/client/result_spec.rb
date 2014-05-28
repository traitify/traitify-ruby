require "spec_helper"

describe Traitify::Client do
  before do
    Traitify.configure do |tom|
      tom.secret = "secret"
      tom.api_host = "https://example.com"
      tom.api_version = "v1"
    end
  end

  let(:tom) { Traitify.new }

  describe ".find_results" do
    let(:result) { tom.find_results("assessment-uuid") }

    before(:each) do
      stub_it(:get, "/assessments/assessment-uuid/personality_types", "result")
    end

    it "returns a result" do
      expect(result.personality_types.first.name).to eq("Analyzer")
    end
  end
end
