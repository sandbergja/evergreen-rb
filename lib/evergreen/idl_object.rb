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
  end
end
