require "spec_helper"

describe Traitify::Client::Model do
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

  describe ".all" do
    it "returns response" do
      stub_it(:get, "/profiles?locale_key=en-us", "blank")

      expect(client.profiles.find).to be_instance_of(Traitify::Response)
    end

    it "sends params" do
      stub_it(:get, "/profiles?foo=bar&locale_key=en-us", "blank")

      expect(client.profiles.find(foo: :bar)).to be_instance_of(Traitify::Response)
    end
  end

  describe ".create" do
    it "returns response" do
      stub_it(:post, "/profiles", "blank", body: {locale_key: "en-us"})

      expect(client.profiles.create).to be_instance_of(Traitify::Response)
    end

    it "sends params" do
      stub_it(:post, "/profiles", "blank", body: {foo: "bar", locale_key: "en-us"})

      expect(client.profiles.create(foo: :bar)).to be_instance_of(Traitify::Response)
    end
  end

  describe ".destroy" do
    it "returns response" do
      stub_it(:delete, "/profiles?locale_key=en-us", "blank")

      expect(client.profiles.destroy).to be_instance_of(Traitify::Response)
    end

    it "sends params" do
      stub_it(:delete, "/profiles/profile-id?locale_key=en-us", "blank")

      expect(client.profiles("profile-id").destroy).to be_instance_of(Traitify::Response)
    end
  end

  describe ".update" do
    it "returns response" do
      stub_it(:put, "/profiles/profile-id", "blank", body: {foo: "bar", locale_key: "en-us"})

      expect(client.profiles("profile-id").update(foo: :bar)).to be_instance_of(Traitify::Response)
    end

    it "uses verb" do
      stub_it(:patch, "/profiles/profile-id", "blank", body: {foo: "bar", locale_key: "en-us"})

      expect(client.profiles("profile-id").update({foo: :bar}, :patch)).to(
        be_instance_of(Traitify::Response)
      )
    end
  end
end
