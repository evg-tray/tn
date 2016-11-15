require_relative "modules/instance_counter"

class A
  include InstanceCounter

  def initialize
    register_instance
  end
end

5.times{A.new}
begin
  A.instances = 10
rescue
  puts "Ошибка установки"
end
puts A.instances
