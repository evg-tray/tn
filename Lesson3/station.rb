class Station
  attr_reader :name_station

  def initialize(name_station)
    @name_station = name_station
    @trains_on_station = []
  end

  def take_train(train)
    @trains_on_station << train
  end

  def print_trains
    @trains_on_station.each { |train| puts train.number }
  end

  def print_count_trains_by_type
    count_freigh_trains = 0
    count_passenger_trains = 0
    count_unknown_train = 0
    @trains_on_station.each { |train|
      if train.type == "freigh"
        count_freigh_trains += 1
      elsif train.type == "passenger"
        count_passenger_trains += 1
      else
        count_unknown_train += 1
      end
    }
    puts "На станции грузовых: #{count_freigh_trains.to_s}, пассажирских #{count_passenger_trains.to_s}, неизвестного типа: #{count_unknown_train.to_s} поездов"
  end

  def send_train(train)
    @trains_on_station.delete(train)
  end

end
