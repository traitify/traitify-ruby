require "spec_helper"

describe Traitify::Response do
  describe ".data" do
    it "returns array from array" do
      request = OpenStruct.new(body: [{traitify: "result"}])
      result = Traitify::Response.new(request).data

      expect(result[0]).to be_instance_of(Traitify::Data)
      expect(result[0].traitify).to eq("result")
    end

    it "returns data from hash" do
      request = OpenStruct.new(body: {traitify: "result"})
      result = Traitify::Response.new(request).data

      expect(result).to be_instance_of(Traitify::Data)
      expect(result.traitify).to eq("result")
    end
  end

  describe ".page" do
    it "returns blank pagination" do
      request = Traitify::Data.new(env: {response_headers: {}})
      result = Traitify::Response.new(request).page

      expect(result.previous).to be_blank
      expect(result.next).to be_blank
    end

    it "returns both pages" do
      previous_url = "http://www.example.com/previous?page=1"
      next_url = "http://www.example.com/next?page=1"
      link = ["<#{previous_url}>; rel=\"prev\"", "<#{next_url}>; rel=\"next\""].join(", ")
      request = Traitify::Data.new(env: {response_headers: {link: link}})
      result = Traitify::Response.new(request).page

      expect(result.next.params.page).to eq(["1"])
      expect(result.next.url).to eq(next_url)
      expect(result.previous.params.page).to eq(["1"])
      expect(result.previous.url).to eq(previous_url)
    end

    it "returns next page" do
      next_url = "http://www.example.com/next?page=1"
      link = ["<#{next_url}>; rel=\"next\""].join(", ")
      request = Traitify::Data.new(env: {response_headers: {link: link}})
      result = Traitify::Response.new(request).page

      expect(result.next.params.page).to eq(["1"])
      expect(result.next.url).to eq(next_url)
      expect(result.previous).to be_blank
    end

    it "returns previous page" do
      previous_url = "http://www.example.com/previous?page=1"
      link = ["<#{previous_url}>; rel=\"prev\""].join(", ")
      request = Traitify::Data.new(env: {response_headers: {link: link}})
      result = Traitify::Response.new(request).page

      expect(result.next).to be_blank
      expect(result.previous.params.page).to eq(["1"])
      expect(result.previous.url).to eq(previous_url)
    end
  end

  describe ".total" do
    it "returns nothing" do
      request = Traitify::Data.new(env: {response_headers: {}})
      result = Traitify::Response.new(request).total

      expect(result).to be_blank
    end

    it "returns total" do
      request = Traitify::Data.new(env: {response_headers: {"x-total-count" => 10}})
      result = Traitify::Response.new(request).total

      expect(result).to eq(10)
    end
  end
end
