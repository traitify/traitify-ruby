module Traitify
  class Client
    module Locale
      def locales(options = {})
        options[:no_locale] = true
        get("/locales", options).collect { |locale| Hashie::Mash.new(locale) }
      end

      def locale(id, options = {})
        options[:no_locale] = true
        Hashie::Mash.new get("/locales/#{id}", options)
      end
    end
  end
end
