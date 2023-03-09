# frozen_string_literal: true

require 'open-uri'
require 'rexml/parsers/sax2parser'
require 'rexml/sax2listener'

class Evergreen
  # Evergreen's fieldmapper IDL
  class IDL
    attr_reader :fields

    def initialize(configuration)
      @configuration = configuration
      @handler = IDLSaxHandler.new
      fetch
      freeze
    end

    def [](key)
      fields[key]
    end

    private

    def fetch
      begin
        URI.open("https://#{@configuration.host}/reports/fm_IDL.xml") do |file|
          parser = REXML::Parsers::SAX2Parser.new(file)
          parser.listen(@handler)
          parser.parse
        end
      rescue Errno::ECONNREFUSED, OpenURI::HTTPError
        raise Evergreen::ConnectionError
      end
      @fields = @handler.idl_fields
    end

    # A SAX parsing handler
    class IDLSaxHandler
      include REXML::SAX2Listener
      attr_accessor :idl_fields

      def initialize
        @idl_fields = {}
        super
      end

      # Callback for when we hit an XML attribute
      def start_element(_uri, _localname, _qname, attributes)
        if attributes.key? 'id'
          # We found a class ID!
          @current_class = attributes['id']
          @idl_fields[@current_class] = []
        elsif attributes.key? 'name'
          # We found the name of a field!
          @idl_fields[@current_class].push(attributes['name'])
        end
      end
    end
  end
end
