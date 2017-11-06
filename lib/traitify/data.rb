module Traitify
  class Data < OpenStruct
    def self.new(data)
      case data
      when Array
        return data.collect { |row| self.new row }
      when Hash
        super data.transform_values { |value| self.new value }
      else data
        return data
      end
    end

    def as_json(*args)
      super.as_json["table"]
    end
  end
end
