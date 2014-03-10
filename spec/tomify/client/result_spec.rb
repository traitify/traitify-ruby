require "spec_helper"

describe Tomify::Client do
  before do
    Tomify.configure do |tom|
      tom.secret = "secret"
      tom.api_host = "example.com"
      tom.api_version = "v1"
    end
  end

  let(:tom) { Tomify.new }

  describe ".find_results" do
    let(:result) { tom.find_results("assessment-uuid") }

    before(:each) do
      stub_it(:get, "/assessments/assessment-uuid/results", "result")
    end

    it "returns a result" do
      expect(result.personality_types.first.name).to eq("Creator")
    end
  end
end
