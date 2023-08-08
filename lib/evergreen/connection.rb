# frozen_string_literal: true

class Evergreen
  # This class provides an interface for making
  # requests to the Evergreen server
  class Connection
    include Mixins::RetrievalMethods
    attr_reader :configuration

    def initialize(configuration:)
      @configuration = configuration
    end

    def close; end

    def idl
      @idl ||= IDL.new(@configuration)
    end
  end
end
