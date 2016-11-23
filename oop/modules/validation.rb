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
      method_name = "validate_#{name}_#{type}!"
      define_method(method_name) do
        var = instance_variable_get("@#{name}".to_sym)
        case type
        when :presence
          raise "#{name} don't must be nil" if var.nil?
        when :format
          raise "Wrong format: #{name}" if var !~ option
        when :type
          raise "Wrong type: #{name}" unless var.is_a? option
        end
      end
      @validations ||= []
      @validations << method_name
    end
  end

  module InstanceMethods
    def validate!
      self.class.validations.each { |method| eval(method) }
    end

    def valid?
      validate!
      true
    rescue
      false
    end
  end
end
