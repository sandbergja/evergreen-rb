# frozen_string_literal: true

require_relative 'evergreen/configuration'
require_relative 'evergreen/idl'
require_relative 'evergreen/version'

module Evergreen
  class ConnectionError < StandardError; end
end
