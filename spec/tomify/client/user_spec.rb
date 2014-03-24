require "spec_helper"

describe Tomify::Client do
  before do
    Tomify.configure do |tom|
      tom.secret = "secret"
      tom.api_host = "https://example.com"
      tom.api_version = "v1"
    end
  end

  let(:tom) { Tomify.new }

  describe ".create_user" do
    let(:user) { tom.create_user(
      first_name: "Tom",
      last_name: "Prats",
      email: "tom@tomprats.com"
    )}

    before(:each) do
      stub_it(:post, "/users", "user")
    end

    it "returns a user" do
      expect(user.first_name).to eq("Tom")
    end
  end

  describe ".find_user" do
    let(:user) { tom.find_user("toms-uuid") }

    before(:each) do
      stub_it(:get, "/users/toms-uuid", "user")
    end

    it "returns a user" do
      expect(user.id).to eq("toms-uuid")
    end
  end
end
