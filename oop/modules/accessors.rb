module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      raise TypeError.new("Name is not symbol") unless name.is_a?(Symbol)
      var_name = "@#{name}".to_sym
      method_name_hist = "#{name}_history"
      var_name_hist = "@#{method_name_hist}".to_sym
      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}=".to_sym) do |value|
        instance_variable_set(var_name, value)
        instance_variable_set(var_name_hist, eval(method_name_hist) << value)
      end
      define_method(method_name_hist) do
        instance_variable_get(var_name_hist) || []
      end
    end
  end

  def strong_attr_acessor(name, class_name)
    raise TypeError.new("Name is not symbol") unless name.is_a?(Symbol)
    var_name = "@#{name}".to_sym
    define_method(name) { instance_variable_get(var_name) }
    define_method("#{name}=".to_sym) do |value|
      raise TypeError.new("Type mismatch!") unless class_name === value
      instance_variable_set(var_name, value)
    end
  end
end
