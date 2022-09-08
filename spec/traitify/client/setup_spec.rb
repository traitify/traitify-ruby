require "spec_helper"

describe Traitify::Client::Setup do
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

  describe ".add_params" do
    it "adds param" do
      client.set(params: {this: "that"})
      client.add_params(foo: "bar", vampire: "weekend")

      expect(client.params).to match({foo: "bar", this: "that", vampire: "weekend"})
    end

    it "overrides param" do
      client.set(params: {foo: "bar", this: "that"})
      client.add_params(foo: "boo", vampire: "weekend")

      expect(client.params).to match({foo: "boo", this: "that", vampire: "weekend"})
    end
  end

  describe ".add_path" do
    it "adds path" do
      client.set(path: "/little")
      client.add_path("/path")

      expect(client.path).to eq("/little/path")
    end

    it "creates path" do
      client.add_path("/path")

      expect(client.path).to eq("/path")
    end
  end

  describe ".set_param" do
    it "overrides param" do
      client.set(params: {foo: "bar", this: "that"})
      client.set_param(:foo, "boo")

      expect(client.params).to match({foo: "boo", this: "that"})
    end

    it "sets param" do
      client.set(params: {this: "that"})
      client.set_param(:foo, "bar")

      expect(client.params).to match({foo: "bar", this: "that"})
    end
  end
end
