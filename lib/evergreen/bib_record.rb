# frozen_string_literal: true

require 'marc'
require 'stringio'

class Evergreen
  # A bibliographic record (title)
  class BibRecord < IDLObject
    include Mixins::AnonymousPcrud
    def initialize(id:, configuration:, idl:)
      @id = id
      @configuration = configuration
      super(idl)
    end

    # rubocop:disable Naming/MemoizedInstanceVariableName
    def to_marc
      @marc ||= MARC::XMLReader.new(StringIO.new(data[idl_fields.index('marc')])).first
    end
    # rubocop:enable Naming/MemoizedInstanceVariableName

    def idl_class
      'bre'
    end
  end
end
