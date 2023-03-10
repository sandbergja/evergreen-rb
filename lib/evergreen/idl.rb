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
      URI.open("https://#{@configuration.host}/reports/fm_IDL.xml") do |file|
        @fields = IDLSaxParser.new(file).parse
      end
    rescue Errno::ECONNREFUSED, OpenURI::HTTPError
      raise Evergreen::ConnectionError
    end

    # A wrapper around the SAX parser
    class IDLSaxParser
      def initialize(file)
        @parser = REXML::Parsers::SAX2Parser.new(file)
        @handler = IDLSaxHandler.new
      end

      def parse
        @parser.listen(@handler)
        @parser.parse
        @handler.idl_fields
      end
    end

    # A SAX parsing handler
    class IDLSaxHandler
      include REXML::SAX2Listener
      attr_reader :idl_fields

      def initialize
        @idl_fields = {}
        @current_class = nil
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
