require "./train.rb"

class Station
  attr_reader :name

  def initialize(name_station)
    @name = name_station
    @trains_on_station = []
  end

  def take_train(train)
    @trains_on_station << train
  end

  def print_trains
    @trains_on_station.each { |train| puts train.number }
  end

  def print_count_trains_by_type
    puts "На станции поездов:"
    Train::TYPES.each_with_index do |type, index|
        count = @trains_on_station.count{ |train| train.type == type }
        puts "#{index + 1}. #{type}: #{count}" if count > 0
    end
  end

  def send_train(train)
    @trains_on_station.delete(train)
  end

end
