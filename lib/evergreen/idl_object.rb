# frozen_string_literal: true

class Evergreen
  # A base class for any object represented in
  # Evergreen's IDL
  class IDLObject
    def initialize(idl)
      @idl = idl
    end

    def idl_fields
      @idl[idl_class]
    end

    def get(field_name)
      data[idl_fields.index(field_name)]
    end

    private

    # This should be overriden by subclasses
    def idl_class
      'acp'
    end

    def data; end
  end
end
