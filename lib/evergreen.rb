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
  include Mixins::RetrievalMethods
  attr_accessor :configuration

  def initialize
    @configuration = Configuration.new
    yield(configuration) if block_given?
    @configuration.configuration_complete
  end

  def idl
    @idl ||= IDL.new(@configuration)
  end

  class ConnectionError < StandardError; end
end
