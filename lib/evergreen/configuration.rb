# frozen_string_literal: true

module Evergreen # :nodoc:
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new(validate_and_freeze: false)
    yield(configuration) if block_given?
    configuration.check_required_fields
    configuration.freeze
  end

  # Global configuration for this gem
  class Configuration
    attr_accessor :host, :default_username, :default_password, :read_only

    def initialize(host: nil, default_username: nil, default_password: nil, read_only: true, validate_and_freeze: true)
      @host = host
      @default_username = default_username
      @default_password = default_password
      @read_only = read_only
      check_required_fields if validate_and_freeze
      freeze if validate_and_freeze
    end

    def check_required_fields
      raise ArgumentError, 'you must supply a host' if field_is_empty :host
      return unless !@read_only && (field_is_empty(:default_username) || field_is_empty(:default_password))

      raise ArgumentError, 'you must supply default credentials unless you are in read-only mode'
    end

    private

    def field_is_empty(field_name)
      field_value = instance_variable_get("@#{field_name}")
      field_value.nil? || field_value.empty?
    end
  end
end
