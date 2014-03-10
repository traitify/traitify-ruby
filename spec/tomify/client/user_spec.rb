require "spec_helper"

describe Tomify::Client do
  before do
    Tomify.configure do |tom|
      tom.api_host = "example.com"
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
      stub_it(
        :put,
       "/users?user%5Bemail%5D=tom@tomprats.com&user%5Bfirst_name%5D=Tom&user%5Blast_name%5D=Prats",
       "user"
      )
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
