# frozen_string_literal: true

require 'zeitwerk'
loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect(
  'http_translator_request' => 'HTTPTranslatorRequest',
  'idl' => 'IDL',
  'idl_object' => 'IDLObject',
  'opensrf' => 'OpenSRF',
  'json' => 'JSON'
)
loader.setup

# The main class provided by this gem
class Evergreen
  def initialize(config_hash)
    connection = Connection.new(configuration: Configuration.new(config_hash))
    yield connection
    connection.close
  end

  # An error when we can't connect to the Evergreen server
  class ConnectionError < StandardError; end
end
