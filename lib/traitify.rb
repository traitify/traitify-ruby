require "active_support"
require "active_support/core_ext/object/deep_dup"
require "ostruct"
require "jwt"
require "openssl"
require "traitify/configuration"
require "traitify/client"
require "traitify/data"
require "traitify/error"
require "traitify/response"
require "traitify/version"
require "logger"

module Traitify
  extend Configuration

  self.host = "http://api-sandbox.traitify.com"
  self.version = "v1"
  self.locale_key = "en-us"

  class << self
    attr_writer :logger

    def new(options = {})
      Traitify::Client.new(options)
    end

    def logger
      @logger ||= Logger.new($stdout).tap do |log|
        log.progname = name
      end
    end

    def log(level, message)
      message = "[traitify-ruby] #{message}"
      case level
      when :debug
        logger.debug message
      when :warn
        logger.warn message
      when :error
        logger.error message
      else
        logger.info message
      end
    end

    def valid_jwt_token?(token)
      algorithm = "RS256"
      return false unless jwt_public_keys && jwt_public_keys.any?

      public_keys = jwt_public_keys.map { |key| OpenSSL::PKey::RSA.new(key) }

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
        log(:warn, "[JWT] #{e.class.name}: #{e.message}")
        next
      rescue => e
        log(:error, "[JWT] Unexpected error: #{e.class} - #{e.message}")
        next
      end

      false
    end

    private

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
  end
end
