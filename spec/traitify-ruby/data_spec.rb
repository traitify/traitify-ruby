require "spec_helper"

describe Traitify::Data do
  describe "#new" do
    context "with array" do
      it "returns array" do
        data = Traitify::Data.new([])

        expect(data).to eq([])
      end

      it "converts each element" do
        data = Traitify::Data.new([{traitify: ""}])

        expect(data[0]).to be_a(Traitify::Data)
      end
    end

    context "with hash" do
      it "returns data" do
        data = Traitify::Data.new({})

        expect(data).to be_a(Traitify::Data)
      end

      it "converts each value" do
        data = Traitify::Data.new({traitify: {}})

        expect(data.traitify).to be_a(Traitify::Data)
      end
    end

    context "with simple objects" do
      it "returns boolean" do
        data = Traitify::Data.new(true)

        expect(data).to eq(true)
      end

      it "returns number" do
        data = Traitify::Data.new(42)

        expect(data).to eq(42)
      end

      it "returns string" do
        data = Traitify::Data.new("Traitify")

        expect(data).to eq("Traitify")
      end

      it "returns symbol" do
        data = Traitify::Data.new(:traitify)

        expect(data).to eq(:traitify)
      end
    end
  end

  describe ".as_json" do
    context "with array" do
      it "returns array" do
        data = Traitify::Data.new([])

        expect(data.as_json).to eq([])
      end

      it "returns equivalent elements" do
        data = Traitify::Data.new([{traitify: ""}])

        expect(data.as_json.map(&:symbolize_keys)).to eq([{traitify: ""}])
      end
    end

    context "with hash" do
      it "returns data" do
        data = Traitify::Data.new({})

        expect(data.as_json).to eq({})
      end

      it "returns equivalent values" do
        data = Traitify::Data.new({traitify: {}})

        expect(data.as_json.symbolize_keys).to eq({traitify: {}})
      end
    end
  end
end
