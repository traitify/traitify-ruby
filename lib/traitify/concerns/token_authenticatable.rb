require "jwt"
require "json"
require "openssl"

module Traitify
  module Concerns
    module TokenAuthenticatable
      extend ActiveSupport::Concern

      included do
        before_action :authenticate_with_token
      end

      private

      def authenticate_with_token
        token = extract_token_from_header

        return render_unauthorized("Missing token") if token.nil?
        render_unauthorized("Invalid token") unless valid_token?(token)
      end

      def extract_token_from_header
        auth_header = request.headers["Authorization"]
        auth_header&.split(" ")&.last
      end

      def render_unauthorized(message)
        render json: {error: message}, status: :unauthorized
      end

      def valid_token?(token)
        algorithm = "RS256"
        public_keys = load_public_keys

        public_keys.each do |public_key|
          decoded_token = JWT.decode(token, public_key, true, {
            algorithm: algorithm,
            iss: "Traitify by Paradox",
            verify_iss: true,
            verify_iat: true,
            verify_nbf: true,
            verify_jti: true
          })

          payload = decoded_token[0]
          validate_claims(payload)
          return true
        rescue JWT::ExpiredSignature, JWT::DecodeError, JWT::VerificationError => e
          Rails.logger.warn("[JWT] #{e.class.name}: #{e.message}")
          next
        rescue => e
          Rails.logger.error("[JWT] Unexpected error: #{e.class} - #{e.message}")
          next
        end

        false
      end

      def validate_claims(payload)
        current_time = Time.now.to_i

        iat_value = payload["iat"] || payload[:iat]
        if iat_value && iat_value > current_time
          raise JWT::InvalidIatError.new("Token issued in the future")
        end

        nbf_value = payload["nbf"] || payload[:nbf]
        if nbf_value && nbf_value > current_time
          raise JWT::DecodeError.new("Token not yet valid")
        end

        jti_value = payload["jti"] || payload[:jti]
        if jti_value.nil? || jti_value.empty?
          raise JWT::DecodeError.new("Missing JWT ID (jti)")
        end
      end

      def load_public_keys
        keys = []

        if ENV["JWT_PUBLIC_KEY"] && !ENV["JWT_PUBLIC_KEY"].empty?
          keys << OpenSSL::PKey::RSA.new(ENV["JWT_PUBLIC_KEY"])
        end

        if ENV["JWT_PUBLIC_KEY_LEGACY"] && !ENV["JWT_PUBLIC_KEY_LEGACY"].empty?
          keys << OpenSSL::PKey::RSA.new(ENV["JWT_PUBLIC_KEY_LEGACY"])
        end

        if keys.empty?
          raise "No JWT public keys configured. Set JWT_PUBLIC_KEY or " \
                "JWT_PUBLIC_KEY_LEGACY environment variable"
        end

        keys
      end
    end
  end
end
