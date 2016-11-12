class Wagon
  attr_accessor :train
  attr_reader :number

  def initialize(number)
    @number = number
  end

  def can_hitch?
    @train.nil?
  end
end
