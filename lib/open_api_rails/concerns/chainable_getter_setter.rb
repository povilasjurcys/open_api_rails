# frozen_string_literal: true

module OpenApiRails
  # Adds as_chainable_getter_setter method to the class instance
  module ChainableGetterSetter
    # Class methods
    module ClassMethods
      def chainable_getter_setter(method_name)
        define_method(method_name) do |value = UNDEFINED|
          as_chainable_getter_setter(method_name, value)
        end
      end
    end

    UNDEFINED = Object.new.freeze

    def self.included(base)
      base.extend ClassMethods
    end

    def as_chainable_getter_setter(key, value)
      return instance_variable_get("@#{key}") if value == UNDEFINED

      instance_variable_set("@#{key}", value)
      self
    end
  end
end
