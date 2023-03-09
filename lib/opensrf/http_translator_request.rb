# frozen_string_literal: true

require 'json'
require 'net/http'
require 'uri'

module OpenSRF
  # A stateful endpoint, described in
  # this documentation:
  # https://docs.evergreen-ils.org/eg/docs/latest/integrations/web_services.html#_http_translator
  class HTTPTranslatorRequest
    def initialize(configuration:, service:, payload:)
      @configuration = configuration
      @service = service
      @payload = payload
    end

    def response
      raw = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end
      OpenSRF::JSON.parse(::JSON.parse(raw.body).first, ['payload']).data
    end

    private

    def request
      request = Net::HTTP::Post.new(uri)
      request['X-Opensrf-Service'] = @service
      request.body = "osrf-msg=#{osrf_message.to_json}"
      request
    end

    def osrf_message
      [
        OpenSRF::JSON.new(klass: 'osrfMessage', data: {
                            'threadTrace' => 0,
                            'locale' => 'en-CA',
                            'type' => 'REQUEST',
                            'payload' => @payload
                          }).to_h
      ]
    end

    def req_options
      { use_ssl: uri.scheme == 'https' }
    end

    def uri
      URI.parse("https://#{@configuration.host}/osrf-http-translator")
    end
  end
end
