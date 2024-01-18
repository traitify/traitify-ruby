require "spec_helper"

describe Traitify::Client do
  before do
    Traitify.configure do |client|
      client.secret_key = "secret"
      client.host = "https://example.com"
      client.version = "v1"
      client.deck_id = "deck-uuid"
      client.logger = Logger.new("/dev/null")
    end
  end

  let(:client){ Traitify.new(auto_retry: false) }

  describe ".auto_retry" do
    it "is set to true" do
      client = Traitify.new(auto_retry: true)

      expect(client.auto_retry).to eq(true)
    end

    it "is set to false" do
      expect(client.auto_retry).to eq(false)
    end
  end

  describe ".retriable" do
    it "sets auto_retry" do
      expect(client.retriable.auto_retry).to eq(true)
    end

    it "sets retry_options" do
      expect(client.retriable(retry_statuses: [500]).retry_options).to match(
        retry_statuses: [500]
      )
    end

    it "uses existing retry_options" do
      client = Traitify.new(retry_options: {retry_statuses: [500]})

      expect(client.retriable.retry_options).to match(
        retry_statuses: [500]
      )
    end

    it "is retriable when extended" do
      expect(client.retriable.profiles.auto_retry).to eq(true)
    end

    it "is retriable when nested" do
      expect(client.profiles.retriable.auto_retry).to eq(true)
    end

    it "doesn't leak" do
      expect(client.retriable.auto_retry).to eq(true)
      expect(client.profiles.auto_retry).to eq(false)
    end
  end
end
