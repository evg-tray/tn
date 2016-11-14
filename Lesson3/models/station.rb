class Station
  attr_reader :name
  @@stations = []

  def initialize(name_station)
    @name = name_station
    @trains_on_station = []
    @@stations << self
  end

  def take_train(train)
    @trains_on_station << train
  end

  def print_trains
    @trains_on_station.each { |train| puts train.number }
  end

  def print_count_trains_by_type
    puts "На станции поездов:"
    types_trains = @trains_on_station.uniq { |train| train.class }
    types_trains.each_with_index do |classtype, index|
      count = @trains_on_station.count{ |train| train.class == classtype.class }
      puts "#{index + 1}. #{classtype.class.type}: #{count}" if count > 0
    end
  end

  def send_train(train)
    @trains_on_station.delete(train)
  end

  def self.all
    @@stations
  end

end
