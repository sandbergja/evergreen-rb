# frozen_string_literal: true

module OpenSRF
  # OpenSRF requests and responses often
  # take the following form
  # {"__c": "clasname", "__p": ["all", "the", "data"]}
  class JSON
    def initialize(klass:, data:)
      @klass = klass
      @data = data
    end

    def to_h
      { '__c' => @klass,
        '__p' => @data }
    end
  end
end
