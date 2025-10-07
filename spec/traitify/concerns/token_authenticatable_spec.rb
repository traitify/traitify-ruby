require "spec_helper"

describe Traitify::Concerns::TokenAuthenticatable do
  # Create a test controller class that includes the concernmodule
  let(:test_controller_class) do
    Class.new do
      def self.before_action(method_name)
        # Do nothing in test environment
      end

      include Traitify::Concerns::TokenAuthenticatable

      attr_accessor :request, :response

      def initialize
        @request = Object.new
        @response = Object.new
      end

      attr_reader :request
    end
  end

  let(:controller){ test_controller_class.new }

  before do
    ENV.delete("JWT_PUBLIC_KEY")
    ENV.delete("JWT_PUBLIC_KEY_LEGACY")
  end

  describe "#authenticate_with_token" do
    context "when no authorization header is present" do
      before do
        allow(controller.request).to receive(:headers).and_return({})
      end

      it "renders unauthorized error" do
        expect(controller).to receive(:render).with(
          json: {error: "Missing token"},
          status: :unauthorized
        )

        controller.send(:authenticate_with_token)
      end
    end

    context "when authorization header is present but token is blank" do
      before do
        allow(controller.request).to receive(:headers).and_return({"Authorization" => ""})
      end

      it "renders unauthorized error" do
        expect(controller).to receive(:render).with(
          json: {error: "Missing token"},
          status: :unauthorized
        )

        controller.send(:authenticate_with_token)
      end
    end

    context "when valid token is present" do
      let(:valid_token){ "valid.jwt.token" }

      before do
        allow(controller.request).to receive(:headers)
          .and_return({"Authorization" => "Bearer #{valid_token}"})
        allow(controller).to receive(:valid_token?).with(valid_token).and_return(true)
      end

      it "does not render any error" do
        expect(controller).not_to receive(:render)

        controller.send(:authenticate_with_token)
      end
    end

    context "when invalid token is present" do
      let(:invalid_token){ "invalid.jwt.token" }

      before do
        allow(controller.request).to receive(:headers)
          .and_return({"Authorization" => "Bearer #{invalid_token}"})
        allow(controller).to receive(:valid_token?).with(invalid_token).and_return(false)
      end

      it "renders unauthorized error" do
        expect(controller).to receive(:render).with(
          json: {error: "Invalid token"},
          status: :unauthorized
        )

        controller.send(:authenticate_with_token)
      end
    end
  end

  describe "#valid_token?" do
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
      ENV["JWT_PUBLIC_KEY"] = public_key.to_pem
    end

    context "with valid token" do
      let(:valid_token) do
        JWT.encode(valid_payload, private_key, "RS256")
      end

      it "returns true" do
        expect(controller.send(:valid_token?, valid_token)).to be true
      end
    end

    context "with invalid signature" do
      let(:invalid_token) do
        other_private_key = OpenSSL::PKey::RSA.new(2048)
        JWT.encode(valid_payload, other_private_key, "RS256")
      end

      it "returns false" do
        expect(controller.send(:valid_token?, invalid_token)).to be false
      end
    end

    context "with malformed token" do
      let(:malformed_token){ "not.a.valid.jwt" }

      it "returns false" do
        expect(controller.send(:valid_token?, malformed_token)).to be false
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
        expect(controller.send(:valid_token?, expired_token)).to be false
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
        expect(controller.send(:valid_token?, wrong_issuer_token)).to be false
      end
    end

    context "with multiple public keys" do
      let(:legacy_private_key){ OpenSSL::PKey::RSA.new(2048) }
      let(:legacy_public_key){ legacy_private_key.public_key }

      before do
        ENV["JWT_PUBLIC_KEY_LEGACY"] = legacy_public_key.to_pem
      end

      context "when token is signed with current key" do
        let(:current_token) do
          JWT.encode(valid_payload, private_key, "RS256")
        end

        it "returns true" do
          expect(controller.send(:valid_token?, current_token)).to be true
        end
      end

      context "when token is signed with legacy key" do
        let(:legacy_token) do
          JWT.encode(valid_payload, legacy_private_key, "RS256")
        end

        it "returns true" do
          expect(controller.send(:valid_token?, legacy_token)).to be true
        end
      end
    end

    context "when no public keys are configured" do
      before do
        ENV.delete("JWT_PUBLIC_KEY")
        ENV.delete("JWT_PUBLIC_KEY_LEGACY")
      end

      it "raises an error" do
        expect{
          controller.send(:valid_token?, "any.token")
        }.to raise_error(/No JWT public keys configured/)
      end
    end
  end

  describe "#validate_claims" do
    let(:current_time){ Time.now.to_i }

    context "with valid claims" do
      let(:valid_payload) do
        {
          iat: current_time - 100,
          nbf: current_time - 50,
          jti: "unique-token-id"
        }
      end

      it "does not raise an error" do
        expect{ controller.send(:validate_claims, valid_payload) }.not_to raise_error
      end
    end

    context "with future iat" do
      let(:future_iat_payload) do
        {
          iat: current_time + 100,
          nbf: current_time - 50,
          jti: "unique-token-id"
        }
      end

      it "raises InvalidIatError" do
        expect{
          controller.send(:validate_claims,
            future_iat_payload)
        }.to raise_error(JWT::InvalidIatError, "Token issued in the future")
      end
    end

    context "with future nbf" do
      let(:future_nbf_payload) do
        {
          iat: current_time - 100,
          nbf: current_time + 50,
          jti: "unique-token-id"
        }
      end

      it "raises DecodeError" do
        expect{
          controller.send(:validate_claims,
            future_nbf_payload)
        }.to raise_error(JWT::DecodeError, "Token not yet valid")
      end
    end

    context "with missing jti" do
      let(:missing_jti_payload) do
        {
          iat: current_time - 100,
          nbf: current_time - 50
        }
      end

      it "raises DecodeError" do
        expect{
          controller.send(:validate_claims,
            missing_jti_payload)
        }.to raise_error(JWT::DecodeError, "Missing JWT ID (jti)")
      end
    end

    context "with blank jti" do
      let(:blank_jti_payload) do
        {
          iat: current_time - 100,
          nbf: current_time - 50,
          jti: ""
        }
      end

      it "raises DecodeError" do
        expect{
          controller.send(:validate_claims,
            blank_jti_payload)
        }.to raise_error(JWT::DecodeError, "Missing JWT ID (jti)")
      end
    end

    context "with nil jti" do
      let(:nil_jti_payload) do
        {
          iat: current_time - 100,
          nbf: current_time - 50,
          jti: nil
        }
      end

      it "raises DecodeError" do
        expect{
          controller.send(:validate_claims,
            nil_jti_payload)
        }.to raise_error(JWT::DecodeError, "Missing JWT ID (jti)")
      end
    end

    context "with missing iat" do
      let(:missing_iat_payload) do
        {
          nbf: current_time - 50,
          jti: "unique-token-id"
        }
      end

      it "does not raise an error" do
        expect{ controller.send(:validate_claims, missing_iat_payload) }.not_to raise_error
      end
    end

    context "with missing nbf" do
      let(:missing_nbf_payload) do
        {
          iat: current_time - 100,
          jti: "unique-token-id"
        }
      end

      it "does not raise an error" do
        expect{ controller.send(:validate_claims, missing_nbf_payload) }.not_to raise_error
      end
    end
  end

  describe "#load_public_keys" do
    let(:private_key){ OpenSSL::PKey::RSA.new(2048) }
    let(:public_key){ private_key.public_key }

    context "with JWT_PUBLIC_KEY set" do
      before do
        ENV["JWT_PUBLIC_KEY"] = public_key.to_pem
      end

      it "loads the public key" do
        keys = controller.send(:load_public_keys)
        expect(keys.length).to eq(1)
        expect(keys.first).to be_a(OpenSSL::PKey::RSA)
      end
    end

    context "with JWT_PUBLIC_KEY_LEGACY set" do
      let(:legacy_private_key){ OpenSSL::PKey::RSA.new(2048) }
      let(:legacy_public_key){ legacy_private_key.public_key }

      before do
        ENV["JWT_PUBLIC_KEY_LEGACY"] = legacy_public_key.to_pem
      end

      it "loads the legacy public key" do
        keys = controller.send(:load_public_keys)
        expect(keys.length).to eq(1)
        expect(keys.first).to be_a(OpenSSL::PKey::RSA)
      end
    end

    context "with multiple key sources" do
      let(:key1_private){ OpenSSL::PKey::RSA.new(2048) }
      let(:key1_public){ key1_private.public_key }
      let(:key2_private){ OpenSSL::PKey::RSA.new(2048) }
      let(:key2_public){ key2_private.public_key }

      before do
        ENV["JWT_PUBLIC_KEY"] = key1_public.to_pem
        ENV["JWT_PUBLIC_KEY_LEGACY"] = key2_public.to_pem
      end

      it "loads all public keys from all sources" do
        keys = controller.send(:load_public_keys)
        expect(keys.length).to eq(2)
        expect(keys).to all(be_a(OpenSSL::PKey::RSA))
      end
    end

    context "with no keys configured" do
      before do
        ENV.delete("JWT_PUBLIC_KEY")
        ENV.delete("JWT_PUBLIC_KEY_LEGACY")
      end

      it "raises an error" do
        expect{
          controller.send(:load_public_keys)
        }.to raise_error(/No JWT public keys configured/)
      end
    end
  end
end
