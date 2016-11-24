module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    attr_accessor :validations

    def validate(name, type, option = nil)
      raise TypeError.new("Name is not symbol") unless name.is_a?(Symbol)
      is_type = type.is_a?(Symbol) && [:presence, :format, :type].include?(type)
      raise TypeError.new("Unknown type validation") unless is_type
      validate_key = "#{name}_#{type}".to_sym
      @validations ||= {}
      @validations[validate_key] = {name: name, type: type, option: option}
    end
  end

  module InstanceMethods
    def validate!
      current_class = self.class
      until Object === current_class.superclass
        current_class = current_class.superclass
      end
      return unless current_class.instance_variables.include?(:@validations)
      current_class.validations.each_value do |value|
        attribute = instance_variable_get("@#{value[:name]}")
        case value[:type]
        when :presence
          validate_presence(attribute)
        when :format
          validate_format(attribute, value[:option])
        when :type
          validate_type(attribute, value[:option])
        end
      end
    end

    def valid?
      validate!
      true
    rescue
      false
    end

    def validate_presence(attribute)
      raise "#{attribute} don't must be nil" if attribute.nil?
    end

    def validate_format(attribute, format)
      raise "Wrong format: #{attribute}" if attribute !~ format
    end

    def validate_type(attribute, class_name)
      raise "Wrong type: #{attribute}" unless attribute.is_a? class_name
    end
  end
end
