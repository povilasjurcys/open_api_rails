# frozen_string_literal: true

module OpenApiRails
  # Adds type related methods
  module TypeConfigurable
    DEFAULT_TYPE = 'string'

    FORMAT_MAP = {
      'date' => 'date',
      'date_time' => 'date-time',
      'time' => 'date-time',
      'integer' => 'int32',
      'float' => 'float',
      'password' => 'password'
    }.freeze

    TYPE_MAP = {
      'date' => 'string',
      'date_time' => 'string',
      'integer' => 'number',
      'float' => 'number',
      'password' => 'string',
      'string' => 'string',
      'time' => 'string'
    }.freeze

    def nullable_inner_type_name
      type_parser.nullable_inner_type_name
    end

    def basic_type?
      type_name_info.basic_type?
    end

    def open_api_type
      formatted_type(type)
    end

    def type(new_type = nil)
      return @type || DEFAULT_TYPE unless new_type

      reset_type_related_data
      type_format(type_format_from(new_type))

      @type = formatted_type(new_type)
      self
    end

    def type_name_info
      @type_name_info ||= ::OpenApiRails::Attributes::TypeNameInfo.new(type)
    end

    protected

    def reset_type_related_data
      @type_parser = nil
      @type_name_info = nil
    end

    def type_open_api_json
      return {} if type.blank?

      type_parser.open_api_json
    end

    def format_open_api_json
      return {} if type.blank? || type_format.blank?

      { format: type_format.to_s }
    end

    private

    def formatted_type(new_type)
      TYPE_MAP[new_type.to_s.underscore] || new_type
    end

    def type_format_from(type)
      FORMAT_MAP[type.to_s.underscore]
    end
  end
end
