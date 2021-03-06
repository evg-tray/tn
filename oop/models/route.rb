require_relative '../modules/validation'
require_relative 'station'
class Route
  include Validation

  validate :start_station, :type, Station
  validate :end_station, :type, Station

  def initialize(start_station, end_station)
    @stations_in_route = [start_station, end_station]
    validate!
  end

  def start_station
    @stations_in_route.first
  end

  def end_station
    @stations_in_route.last
  end

  def add_station(station)
    validate_argument_station!(station)
    @stations_in_route.insert(-2, station)
  end

  def delete_station(station)
    validate_argument_station!(station)
    return if station == @start_station || station == @end_station
    @stations_in_route.delete(station)
  end

  def print_stations
    @stations_in_route.each { |station| puts station.name }
  end

  def get_next_station(station)
    validate_argument_station!(station)
    @stations_in_route[@stations_in_route.find_index(station).next]
  end

  def get_prev_station(station)
    validate_argument_station!(station)
    station_index = @stations_in_route.find_index(station)
    @stations_in_route[station_index - 1] if station_index > 0
  end

  private

  def validate_argument_station!(station)
    raise 'Переданный параметр не является станцией!' unless station?(station)
  end

  def station?(station)
    station.is_a? Station
  end
end
