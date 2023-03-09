# frozen_string_literal: true

module OpenSRF
  # OpenSRF requests and responses often
  # take the following form
  # {"__c": "clasname", "__p": ["all", "the", "data"]}
  class JSON
    attr_reader :klass, :data

    def initialize(klass:, data:)
      @klass = klass
      @data = data
    end

    def self.parse(hash, path = [])
      small_json = new(klass: hash['__c'], data: hash['__p'])
      return small_json if path.empty?

      key = path.shift
      parse(small_json.data[key], path)
    end

    def to_h
      { '__c' => @klass,
        '__p' => @data }
    end
  end
end
