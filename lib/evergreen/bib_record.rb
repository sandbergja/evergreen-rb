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

    def holdings
      payload = OpenSRF::JSON.new(klass: 'osrfMessage', data: {
                                    'method' => 'open-ils.cat.asset.copy_tree.global.retrieve',
                                    'params' => ['', @id.to_s]
                                  }).to_h
      OpenSRF::HTTPTranslatorRequest.new(payload: payload, configuration: @configuration,
                                         service: 'open-ils.cat').response
    end

    def tcn
      data[idl_fields.index('tcn_value')]
    end

    private

    def idl_class
      'bre'
    end
  end
end
