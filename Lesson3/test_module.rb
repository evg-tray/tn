require_relative "modules/instance_counter"

class A
  include InstanceCounter

  def initialize
    register_instance
  end
end

5.times{A.new}
puts A.instances
