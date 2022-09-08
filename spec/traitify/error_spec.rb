require "spec_helper"

describe Traitify::Error do
  describe "#from" do
    it "creates error from 400" do
      response = Traitify::Data.new(
        body: "string",
        request: {http_method: "get", url: "http://www.example.com"},
        status: 400
      )
      result = Traitify::Error.from(response)

      expect(result).to be_an_instance_of(Traitify::BadRequest)
    end

    it "creates error from 401" do
      response = Traitify::Data.new(
        body: "string",
        request: {http_method: "get", url: "http://www.example.com"},
        status: 401
      )
      result = Traitify::Error.from(response)

      expect(result).to be_an_instance_of(Traitify::Unauthorized)
    end

    it "creates error from 404" do
      response = Traitify::Data.new(
        body: "string",
        request: {http_method: "get", url: "http://www.example.com"},
        status: 404
      )
      result = Traitify::Error.from(response)

      expect(result).to be_an_instance_of(Traitify::NotFound)
    end

    it "creates error from 422" do
      response = Traitify::Data.new(
        body: "string",
        request: {http_method: "get", url: "http://www.example.com"},
        status: 422
      )
      result = Traitify::Error.from(response)

      expect(result).to be_an_instance_of(Traitify::UnprocessableEntity)
    end

    it "creates error from 500" do
      response = Traitify::Data.new(
        body: "string",
        request: {http_method: "get", url: "http://www.example.com"},
        status: 500
      )
      result = Traitify::Error.from(response)

      expect(result).to be_an_instance_of(Traitify::ServerError)
    end

    it "creates nothing from 200" do
      response = Traitify::Data.new(
        body: "string",
        request: {http_method: "get", url: "http://www.example.com"},
        status: 200
      )
      result = Traitify::Error.from(response)

      expect(result).to be_nil
    end
  end

  describe ".message" do
    it "returns error from array" do
      response = Traitify::Data.new(
        body: ["array with string"],
        request: {http_method: "get", url: "http://www.example.com"},
        status: 500
      )
      result = Traitify::Error.new(response).message

      expect(result).to eq("GET | http://www.example.com | 500 | array with string")
    end

    it "returns error from array with object" do
      response = Traitify::Data.new(
        body: [{message: "array with object"}],
        request: {http_method: "get", url: "http://www.example.com"},
        status: 500
      )
      result = Traitify::Error.new(response).message

      expect(result).to eq("GET | http://www.example.com | 500 | array with object")
    end

    it "returns error from object" do
      response = Traitify::Data.new(
        body: {message: "object with message"},
        request: {http_method: "get", url: "http://www.example.com"},
        status: 500
      )
      result = Traitify::Error.new(response).message

      expect(result).to eq("GET | http://www.example.com | 500 | object with message")
    end

    it "returns error from string" do
      response = Traitify::Data.new(
        body: "string",
        request: {http_method: "get", url: "http://www.example.com"},
        status: 500
      )
      result = Traitify::Error.new(response).message

      expect(result).to eq("GET | http://www.example.com | 500 | string")
    end
  end
end
