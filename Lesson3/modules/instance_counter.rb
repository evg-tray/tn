module InstanceCounter

  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_accessor :instances
    private :instances=
  end

  module InstanceMethods
    protected
    def register_instance
      self.class.send :instances=, (self.class.instances || 0) + 1
      #возможно ли заставить работать конструкцию?
      #self.class.instances ||= 0
      #self.class.instances += 1
    end
  end

end
