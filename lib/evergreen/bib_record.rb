# frozen_string_literal: true

require 'marc'
require 'stringio'

class Evergreen
  # A bibliographic record (title)
  class BibRecord < IDLObject
    def initialize(id:, configuration:, idl:)
      @id = id
      @configuration = configuration
      super(idl)
    end

    # rubocop:disable Naming/MemoizedInstanceVariableName
    def to_marc
      @marc ||= MARC::XMLReader.new(StringIO.new(get('marc'))).first
    end
    # rubocop:enable Naming/MemoizedInstanceVariableName

    def holdings
      payload = OpenSRF::ClassAndData.new(klass: 'osrfMessage', data: {
                                            'method' => 'open-ils.cat.asset.copy_tree.global.retrieve',
                                            'params' => ['', @id.to_s]
                                          }).to_h
      OpenSRF::HTTPTranslatorRequest.new(payload: payload, configuration: @configuration,
                                         service: 'open-ils.cat').response
    end

    def tcn
      get 'tcn_value'
    end

    private

    def idl_class
      'bre'
    end

    def data
      return @data if @data
      return unless @id && @configuration && idl_class && idl_fields

      payload = OpenSRF::ClassAndData.new(klass: 'osrfMessage', data: {
                                            'method' => "open-ils.pcrud.retrieve.#{idl_class}",
                                            'params' => ['ANONYMOUS', @id.to_s]
                                          }).to_h
      response = OpenSRF::HTTPTranslatorRequest.new(payload: payload, configuration: @configuration,
                                                    service: 'open-ils.pcrud').response
      @data = OpenSRF::ClassAndData.parse(response['content']).data
    end
  end
end
