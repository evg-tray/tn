require_relative "../modules/manufacturer"
require_relative "../modules/valid"
class Wagon
  attr_accessor :train
  attr_reader :number
  include Manufacturer
  include Valid
  FORMAT_NUMBER = /^[a-zа-я\d]+$/i

  def initialize(number)
    @number = number
    validate!
  end

  def can_be_attached?(type)
    @train.nil? && self.class == type
  end

  protected

  def validate!
    raise "Неправильный формат номера вагона!" if @number !~ FORMAT_NUMBER
  end

end
