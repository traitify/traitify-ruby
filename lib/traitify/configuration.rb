module Traitify
  module Configuration
    VALID_OPTIONS_KEYS = [
      :host,
      :public_key,
      :secret_key,
      :version,
      :deck_id,
      :image_pack,
      :locale_key
    ]

    attr_accessor(*VALID_OPTIONS_KEYS)

    alias_method :api_host, :host
    alias_method :api_host=, :host=

    alias_method :api_version, :version
    alias_method :api_version=, :version=

    alias_method :secret, :secret_key
    alias_method :secret=, :secret_key=

    def configure
      yield self
    end

    def options
      VALID_OPTIONS_KEYS.inject({}){|o,k| o.merge!(k => send(k)) }
    end
  end
end
