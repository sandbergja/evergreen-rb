# frozen_string_literal: true

class Evergreen
  module Mixins
    # This read-only API is available
    # without any credentials
    module AnonymousPcrud
      def data
        return @data if @data
        return unless @id && @configuration && idl_class && idl_fields

        payload = OpenSRF::JSON.new(klass: 'osrfMessage', data: {
                                      'method' => "open-ils.pcrud.retrieve.#{idl_class}",
                                      'params' => ['ANONYMOUS', @id.to_s]
                                    }).to_h
        response = OpenSRF::HTTPTranslatorRequest.new(payload: payload, configuration: @configuration,
                                                      service: 'open-ils.pcrud').response
        @data = OpenSRF::JSON.parse(response['content']).data
      end
    end
  end
end
