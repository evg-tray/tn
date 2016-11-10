class Train
  attr_accessor :speed
  attr_reader :number, :type, :count_wagons

  def initialize(number, type, count_wagons = 0)
    @number = number
    @type = type
    @count_wagons = count_wagons
    @speed = 0
  end

  def stop
    self.speed = 0
  end

  def hitch_wagon
    self.count_wagons += 1 if speed == 0
  end

  def detach_wagon
    self.count_wagons -= 1 if speed == 0
  end

  def route=(route)
    @route = route
    @current_station = @route.start_station
  end

  def goto_next_station
    if @route
      next_station = @route.get_next_station(@current_station)
      @current_station = next_station unless next_station.nil?
    end
  end

  def goto_prev_station
    if @route
      prev_station = @route.get_prev_station(@current_station)
      @current_station = prev_station unless next_station.nil?
    end
  end

  def current_station
    if @route
      puts @current_station.name_station
    else
      puts "Поезду еще не задан маршрут"
    end
  end

  def next_station
    next_station = @route.get_next_station(@current_station)
    if next_station
      puts next_station.name_station
    else
      puts "Мы находимся в конечной станции"
    end
  end

  def prev_station
    prev_station = @route.get_prev_station(@current_station)
    if prev_station
      puts prev_station.name_station
    else
      puts "Мы находимся в начальной станции"
    end
  end
end
