require "spec_helper"

describe Traitify::VERSION do
  it "returns version" do
    expect(Traitify::VERSION).to be_a_kind_of(String)
  end
end
