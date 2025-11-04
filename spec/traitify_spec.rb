require "spec_helper"

describe Traitify do
  describe ".valid_jwt_token?" do
    let(:private_key){ OpenSSL::PKey::RSA.new(2048) }
    let(:public_key){ private_key.public_key }
    let(:valid_payload) do
      {
        iss: "Traitify by Paradox",
        iat: Time.now.to_i,
        nbf: Time.now.to_i,
        jti: "unique-token-id"
      }
    end

    before do
      Traitify.jwt_public_keys = [public_key.to_pem]
    end

    after do
      Traitify.jwt_public_keys = nil
    end

    context "with valid token" do
      let(:valid_token) do
        JWT.encode(valid_payload, private_key, "RS256")
      end

      it "returns true" do
        expect(Traitify.valid_jwt_token?(valid_token)).to be true
      end
    end

    context "with invalid signature" do
      let(:invalid_token) do
        other_private_key = OpenSSL::PKey::RSA.new(2048)
        JWT.encode(valid_payload, other_private_key, "RS256")
      end

      it "returns false" do
        expect(Traitify.valid_jwt_token?(invalid_token)).to be false
      end
    end

    context "with malformed token" do
      let(:malformed_token){ "not.a.valid.jwt" }

      it "returns false" do
        expect(Traitify.valid_jwt_token?(malformed_token)).to be false
      end
    end

    context "with expired token" do
      let(:expired_payload) do
        valid_payload.merge(iat: 1.hour.ago.to_i, exp: 1.hour.ago.to_i)
      end
      let(:expired_token) do
        JWT.encode(expired_payload, private_key, "RS256")
      end

      it "returns false" do
        expect(Traitify.valid_jwt_token?(expired_token)).to be false
      end
    end

    context "with wrong issuer" do
      let(:wrong_issuer_payload) do
        valid_payload.merge(iss: "Wrong Issuer")
      end
      let(:wrong_issuer_token) do
        JWT.encode(wrong_issuer_payload, private_key, "RS256")
      end

      it "returns false" do
        expect(Traitify.valid_jwt_token?(wrong_issuer_token)).to be false
      end
    end

    context "with multiple public keys" do
      let(:legacy_private_key){ OpenSSL::PKey::RSA.new(2048) }
      let(:legacy_public_key){ legacy_private_key.public_key }

      before do
        Traitify.jwt_public_keys = [public_key.to_pem, legacy_public_key.to_pem]
      end

      context "when token is signed with current key" do
        let(:current_token) do
          JWT.encode(valid_payload, private_key, "RS256")
        end

        it "returns true" do
          expect(Traitify.valid_jwt_token?(current_token)).to be true
        end
      end

      context "when token is signed with legacy key" do
        let(:legacy_token) do
          JWT.encode(valid_payload, legacy_private_key, "RS256")
        end

        it "returns true" do
          expect(Traitify.valid_jwt_token?(legacy_token)).to be true
        end
      end
    end

    context "with future iat" do
      let(:future_iat_payload) do
        {
          iss: "Traitify by Paradox",
          iat: Time.now.to_i + 100,
          nbf: Time.now.to_i - 50,
          jti: "unique-token-id"
        }
      end
      let(:future_iat_token) do
        JWT.encode(future_iat_payload, private_key, "RS256")
      end

      it "returns false" do
        expect(Traitify.valid_jwt_token?(future_iat_token)).to be false
      end
    end

    context "with future nbf" do
      let(:future_nbf_payload) do
        {
          iss: "Traitify by Paradox",
          iat: Time.now.to_i - 100,
          nbf: Time.now.to_i + 50,
          jti: "unique-token-id"
        }
      end
      let(:future_nbf_token) do
        JWT.encode(future_nbf_payload, private_key, "RS256")
      end

      it "returns false" do
        expect(Traitify.valid_jwt_token?(future_nbf_token)).to be false
      end
    end

    context "with missing jti" do
      let(:missing_jti_payload) do
        {
          iss: "Traitify by Paradox",
          iat: Time.now.to_i - 100,
          nbf: Time.now.to_i - 50
        }
      end
      let(:missing_jti_token) do
        JWT.encode(missing_jti_payload, private_key, "RS256")
      end

      it "returns false" do
        expect(Traitify.valid_jwt_token?(missing_jti_token)).to be false
      end
    end

    context "with blank jti" do
      let(:blank_jti_payload) do
        {
          iss: "Traitify by Paradox",
          iat: Time.now.to_i - 100,
          nbf: Time.now.to_i - 50,
          jti: ""
        }
      end
      let(:blank_jti_token) do
        JWT.encode(blank_jti_payload, private_key, "RS256")
      end

      it "returns false" do
        expect(Traitify.valid_jwt_token?(blank_jti_token)).to be false
      end
    end

    context "with nil jti" do
      let(:nil_jti_payload) do
        {
          iss: "Traitify by Paradox",
          iat: Time.now.to_i - 100,
          nbf: Time.now.to_i - 50,
          jti: nil
        }
      end
      let(:nil_jti_token) do
        JWT.encode(nil_jti_payload, private_key, "RS256")
      end

      it "returns false" do
        expect(Traitify.valid_jwt_token?(nil_jti_token)).to be false
      end
    end

    context "with missing iat" do
      let(:missing_iat_payload) do
        {
          iss: "Traitify by Paradox",
          nbf: Time.now.to_i - 50,
          jti: "unique-token-id"
        }
      end
      let(:missing_iat_token) do
        JWT.encode(missing_iat_payload, private_key, "RS256")
      end

      it "returns true" do
        expect(Traitify.valid_jwt_token?(missing_iat_token)).to be true
      end
    end

    context "with missing nbf" do
      let(:missing_nbf_payload) do
        {
          iss: "Traitify by Paradox",
          iat: Time.now.to_i - 100,
          jti: "unique-token-id"
        }
      end
      let(:missing_nbf_token) do
        JWT.encode(missing_nbf_payload, private_key, "RS256")
      end

      it "returns true" do
        expect(Traitify.valid_jwt_token?(missing_nbf_token)).to be true
      end
    end

    context "when no public keys are configured" do
      before do
        Traitify.jwt_public_keys = nil
      end

      it "returns false" do
        expect(Traitify.valid_jwt_token?("any.token")).to be false
      end
    end
  end
end

