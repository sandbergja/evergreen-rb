# frozen_string_literal: true

class Evergreen
  # Configuration for an instance of Evergreen
  class Configuration
    attr_reader :host, :default_username, :default_password, :read_only

    def initialize(config_hash)
      @read_only = true
      config_hash.each_pair do |key, value|
        instance_variable_set("@#{key}", value)
      end
      configuration_complete
    end

    private

    def configuration_complete
      check_required_fields
      freeze
    end

    def check_required_fields
      raise ArgumentError, 'you must supply a host' if field_is_empty :host
      return unless !@read_only && (field_is_empty(:default_username) || field_is_empty(:default_password))

      raise ArgumentError, 'you must supply default credentials unless you are in read-only mode'
    end

    def field_is_empty(field_name)
      field_value = instance_variable_get("@#{field_name}")
      field_value.nil? || field_value.empty?
    end
  end
end
