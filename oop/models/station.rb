require_relative '../modules/validation'
require_relative 'train'
class Station
  include Validation

  FORMAT_NAME = /^[a-zа-я\d]+-?[a-zа-я\d]+$/i

  attr_reader :name

  validate :name, :format, FORMAT_NAME
  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name_station)
    @name = name_station
    validate!
    @trains_on_station = []
    @@stations << self
  end

  def take_train(train)
    raise 'Переданный параметр не является поездом!' unless train.is_a? Train
    @trains_on_station << train
  end

  def print_trains
    @trains_on_station.each { |train| puts train.number }
  end

  def print_count_trains_by_type
    puts 'На станции поездов:'
    types_trains = @trains_on_station.uniq(&:class)
    types_trains.each_with_index do |type, index|
      count = @trains_on_station.count { |train| train.class == type.class }
      puts "#{index + 1}. #{type.class.type}: #{count}" if count > 0
    end
  end

  def send_train(train)
    @trains_on_station.delete(train)
  end

  def each_train(&block)
    @trains_on_station.each(&block)
  end

end
