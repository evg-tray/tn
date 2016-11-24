require_relative '../modules/manufacturer'
require_relative '../modules/validation'
class Wagon
  include Manufacturer
  include Validation

  FORMAT_NUMBER = /^[a-zа-я\d]+$/i

  attr_accessor :train
  attr_reader :number

  validate :number, :format, FORMAT_NUMBER

  def initialize(number)
    @number = number
    validate!
  end

  def can_be_attached?(type)
    @train.nil? && self.class == type
  end
end
