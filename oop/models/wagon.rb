require_relative "../modules/manufacturer"
class Wagon
  attr_accessor :train
  attr_reader :number
  include Manufacturer

  def initialize(number)
    @number = number
  end

  def can_be_attached?(type)
    @train.nil? && self.class == type
  end
end
