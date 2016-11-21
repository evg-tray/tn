require_relative 'wagon'
require_relative 'route'
require_relative '../modules/manufacturer'
require_relative '../modules/valid'
class Train
  include Valid
  include Manufacturer

  TYPE = 'Поезд'.freeze
  TYPE_WAGON = Wagon
  FORMAT_NUMBER = /^[a-zа-я\d]{3}-?[a-zа-я\d]{2}$/i

  attr_accessor :speed
  attr_reader :number, :wagons

  @@trains = []

  class << self
    def type
      self::TYPE
    end

    def find(number)
      validate_number!(number)
      @@trains.detect do |train|
        train.number == number && (self == Train || train.class == self)
      end
    end

    protected

    def validate_number!(number)
      raise 'Неправильный формат номера поезда!' if number !~ FORMAT_NUMBER
    end
  end

  def initialize(number)
    @number = number
    validate!
    validate_exist_train!
    @wagons = []
    @speed = 0
    @@trains << self
  end

  def stop
    @speed = 0
  end

  def attach_wagon(wagon)
    validate_wagon!(wagon)
    if stopped? && wagon.can_be_attached?(self.class::TYPE_WAGON)
      @wagons << wagon
      wagon.train = self
      true
    else
      false
    end
  end

  def detach_wagon(wagon)
    validate_wagon!(wagon)
    if stopped? && @wagons.include?(wagon)
      @wagons.delete(wagon)
      wagon.train = nil
      true
    else
      false
    end
  end

  def route=(route)
    raise 'Переданный параметр не является маршрутом!' unless route.is_a? Route
    @route = route
    @current_station = @route.start_station
  end

  def goto_next_station
    validate_route!
    @current_station.send_train(self)
    next_station = @route.get_next_station(@current_station)
    if next_station
      @current_station = next_station
      @current_station.take_train(self)
    else
      goto_depot
    end
  end

  def goto_prev_station
    validate_route!
    @current_station.send_train(self)
    prev_station = @route.get_prev_station(@current_station)
    if prev_station
      @current_station = prev_station
      @current_station.take_train(self)
    else
      goto_depot
    end
  end

  def current_station
    validate_route!
    @current_station
  end

  def next_station
    validate_route!
    next_station = @route.get_next_station(@current_station)
    raise 'Поезд находится в конечной станции!' if next_station.nil?
    next_station
  end

  def prev_station
    validate_route!
    prev_station = @route.get_prev_station(@current_station)
    raise 'Поезд находится в начальной станции!' if prev_station.nil?
    prev_station
  end

  def stopped?
    speed.zero?
  end

  def each_wagon(&block)
    @wagons.each(&block)
  end

  def to_s
    "#{@number}, тип: #{self.class.type}, вагонов: #{@wagons.count}"
  end

  protected

  def validate!
    self.class.send :validate_number!, @number
  end

  def validate_exist_train!
    return unless self.class.find(@number)
    raise "Поезд с номером #{@number} уже существует!"
  end

  def validate_wagon!(wagon)
    raise 'Переданный параметр не является вагоном!' unless wagon.is_a? Wagon
  end

  def validate_route!
    raise 'Поезду не задан маршурт!' if @route.nil?
  end

  private

  def goto_depot
    @current_station = nil
    @route = nil
  end
end
