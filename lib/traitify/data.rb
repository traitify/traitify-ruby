module Traitify
  class Data < OpenStruct
    def self.new(data)
      case data
      when Array
        data.collect{ |row| new row }
      when Hash
        super data.transform_values{ |value| new value }
      else
        data
      end
    end

    def as_json(*args)
      super.as_json["table"]
    end
  end
end
