class Train
  attr_accessor :speed
  attr_reader :number, :wagons

  def initialize(number)
    @number = number
    @wagons = []
    @speed = 0
  end

  def stop
    self.speed = 0
  end

  def hitch_wagon(wagon)
    if stopped? && wagon.can_hitch?
      self.wagons << wagon
      wagon.train = self
      true
    else
      false
    end
  end

  def detach_wagon(wagon)
    if stopped? && @wagons.include?(wagon)
      self.wagons.delete(wagon)
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
    "Поезд"
  end

  private
  #для списка вагонов есть методы удаления/добавления
  attr_writer :wagons
  #поезд в депо отправляется методами перемещения между станциями
  #нельзя отправить его в депо посреди пути
  def goto_depot
    @current_station = nil
    @route = nil
  end

end
