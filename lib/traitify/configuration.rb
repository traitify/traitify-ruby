module Traitify
  module Configuration
    VALID_OPTIONS_KEYS = [
      :host,
      :public_key,
      :secret_key,
      :version,
      :auto_retry,
      :deck_id,
      :image_pack,
      :locale_key,
      :retry_options
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
