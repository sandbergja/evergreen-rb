# frozen_string_literal: true

require 'open-uri'
require 'ox'

module Evergreen
  # Evergreen's fieldmapper IDL
  class IDL
    attr_reader :fields

    def initialize
      @parser = IDLParser.new
      fetch
    end

    def fetch
      begin
        URI.open("https://#{Evergreen.configuration.host}/reports/fm_IDL.xml") do |file|
          Ox.sax_parse(@parser, file)
        end
      rescue Errno::ECONNREFUSED, OpenURI::HTTPError
        raise Evergreen::ConnectionError
      end
      @fields = @parser.idl_fields
    end

    # A SAX parser
    class IDLParser < ::Ox::Sax
      attr_accessor :idl_fields

      def initialize
        @idl_fields = {}
        super
      end

      # Callback for when we hit an XML attribute
      def attr_value(name, value)
        if name == :id
          # We found a class ID!
          @current_class = value.as_s
          @idl_fields[@current_class] = []
        elsif name == :name
          # We found the name of a field!
          @idl_fields[@current_class].push(value.as_s)
        end
      end
    end
  end
end
