class PassengerWagon < Wagon
  attr_reader :count_seats, :busy_seats

  def initialize(number, count_seats)
    super(number)
    @count_seats = count_seats
    validate_count_seats!
    @busy_seats = 0
  end

  def take_passenger
    @busy_seats += 1 if @busy_seats < @count_seats
  end

  def free_seats
    @count_seats - @busy_seats
  end

  def to_s
    "#{@number}, пассажирский, свободные места: #{free_seats}, " \
    "занятые: #{busy_seats}"
  end

  private

  def validate_count_seats!
    raise 'Неверно указано количество мест!' unless @count_seats.is_a? Integer
    raise 'Количество мест должно быть больше 0!' unless @count_seats > 0
  end
end
