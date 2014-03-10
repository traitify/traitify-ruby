module Tomify
  module Configuration
    VALID_OPTIONS_KEYS = [
      :secret,
      :api_host,
      :api_version,
      :deck_id
    ]

    attr_accessor(*VALID_OPTIONS_KEYS)

    def configure
      yield self
    end

    def options
      VALID_OPTIONS_KEYS.inject({}){|o,k| o.merge!(k => send(k)) }
    end
  end
end
