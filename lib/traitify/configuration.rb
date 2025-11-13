module Traitify
  module Configuration
    VALID_OPTIONS_KEYS = [
      :auto_retry,
      :deck_id,
      :host,
      :image_pack,
      :jwt_public_keys,
      :locale_key,
      :public_key,
      :retry_options,
      :secret_key,
      :version
    ].freeze

    attr_accessor(*VALID_OPTIONS_KEYS)

    def configure
      yield self
    end

    def options
      Hash[VALID_OPTIONS_KEYS.collect{ |key| [key, send(key)] }]
    end
  end
end
