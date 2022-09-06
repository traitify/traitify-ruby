require "spec_helper"

describe Traitify::Client::Request do
  before do
    Traitify.configure do |client|
      client.secret_key = "secret"
      client.host = "https://example.com"
      client.version = "v1"
      client.deck_id = "deck-uuid"
      client.logger = Logger.new("/dev/null")
    end
  end

  let(:client){ Traitify.new }

  describe ".delete" do
    it "returns response" do
      stub_it(:delete, "/profiles?locale_key=en-us", "blank")

      expect(client.delete("/profiles")).to be_instance_of(Traitify::Response)
    end

    it "sends params" do
      stub_it(:delete, "/profiles?foo=bar&locale_key=en-us", "blank")

      expect(client.delete("/profiles", foo: :bar)).to be_instance_of(Traitify::Response)
    end
  end

  describe ".get" do
    it "returns response" do
      stub_it(:get, "/profiles?locale_key=en-us", "blank")

      expect(client.get("/profiles")).to be_instance_of(Traitify::Response)
    end

    it "sends params" do
      stub_it(:get, "/profiles?foo=bar&locale_key=en-us", "blank")

      expect(client.get("/profiles", foo: :bar)).to be_instance_of(Traitify::Response)
    end
  end

  describe ".patch" do
    it "returns response" do
      stub_it(:patch, "/profiles", "blank", body: {locale_key: "en-us"})

      expect(client.patch("/profiles")).to be_instance_of(Traitify::Response)
    end

    it "sends params" do
      stub_it(:patch, "/profiles", "blank", body: {foo: "bar", locale_key: "en-us"})

      expect(client.patch("/profiles", foo: :bar)).to be_instance_of(Traitify::Response)
    end
  end

  describe ".post" do
    it "returns response" do
      stub_it(:post, "/profiles", "blank", body: {locale_key: "en-us"})

      expect(client.post("/profiles")).to be_instance_of(Traitify::Response)
    end

    it "sends params" do
      stub_it(:post, "/profiles", "blank", body: {foo: "bar", locale_key: "en-us"})

      expect(client.post("/profiles", foo: :bar)).to be_instance_of(Traitify::Response)
    end
  end

  describe ".put" do
    it "returns response" do
      stub_it(:put, "/profiles", "blank", body: {locale_key: "en-us"})

      expect(client.put("/profiles")).to be_instance_of(Traitify::Response)
    end

    it "sends params" do
      stub_it(:put, "/profiles", "blank", body: {foo: "bar", locale_key: "en-us"})

      expect(client.put("/profiles", foo: :bar)).to be_instance_of(Traitify::Response)
    end
  end
end
