require_relative "wagon"
require_relative "../modules/manufacturer"
class Train
  attr_accessor :speed, :wagons
  attr_reader :number
  private :wagons=
  TYPE = "Поезд"
  TYPE_WAGON = Wagon
  include Manufacturer
  @@trains = []

  def initialize(number)
    if self.class.find(number)
      raise ArgumentError.new("Поезд с номером #{number} уже существует.")
    end
    @number = number
    @wagons = []
    @speed = 0
    @@trains << self
  end

  def stop
    @speed = 0
  end

  def attach_wagon(wagon)
    if stopped? && wagon.can_be_attached?(self.class::TYPE_WAGON)
      @wagons << wagon
      wagon.train = self
      true
    else
      false
    end
  end

  def detach_wagon(wagon)
    if stopped? && @wagons.include?(wagon)
      @wagons.delete(wagon)
      wagon.train = nil
      true
    else
      false
    end
  end

  def route=(route)
    @route = route
    @current_station = @route.start_station
  end

  def goto_next_station
    if @route
      @current_station.send_train(self)
      next_station = @route.get_next_station(@current_station)
      if next_station
        @current_station = next_station
        @current_station.take_train(self)
      else
        self.goto_depot
      end
    end
  end

  def goto_prev_station
    if @route
      @current_station.send_train(self)
      prev_station = @route.get_prev_station(@current_station)
      if prev_station
        @current_station = prev_station
        @current_station.take_train(self)
      else
        self.goto_depot
      end
    end
  end

  def current_station
    if @route
      puts @current_station.name
    else
      puts "Поезду еще не задан маршрут"
    end
  end

  def next_station
    next_station = @route.get_next_station(@current_station)
    message = next_station && name_station.name || "Мы находимся в конечной станции"
    puts message
  end

  def prev_station
    prev_station = @route.get_prev_station(@current_station)
    message = prev_station && prev_station.name || "Мы находимся в начальной станции"
    puts message
  end

  def stopped?
    speed.zero?
  end

  def self.type
    self.class::TYPE
  end

  def self.find(number)
    @@trains.detect { |train| train.number == number && (self == Train || train.class == self) }
  end

  private

  def goto_depot
    @current_station = nil
    @route = nil
  end

end
