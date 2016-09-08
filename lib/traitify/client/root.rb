module Traitify
  module Root
    def profiles(params = {})
      Profiles::Client.new(self).root(params)
    end

    def groups(params = {})
      Groups::Client.new(self).root(params)
    end

    def assessments(params = {})
      Assessments::Client.new(self).root(params)
    end

    def locales(params = {})
      Locales::Client.new(self).root(params)
    end

    def decks(params = {})
      Decks::Client.new(self).root(params)
    end

    def careers(params = {})
      Careers::Client.new(self).root(params)
    end

    def majors(params = {})
      Majors::Client.new(self).root(params)
    end

    def analytics(params = {})
      Analytics::Client.new(self).root(params)
    end
  end
end