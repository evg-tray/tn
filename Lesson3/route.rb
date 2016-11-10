class Route
  attr_reader :start_station, :end_station

  def initialize(start_station, end_station)
    @start_station = start_station
    @end_station = end_station
    @stations_in_route = [start_station, end_station]
  end

  def add_station(station)
    @stations_in_route.insert(-2, station)
  end

  def delete_station(station)
    @stations_in_route.delete(station) if station != start_station && station != end_station
  end

  def print_stations
    @stations_in_route.each { |station| puts station.name_station }
  end

  def get_next_station(station)
    @stations_in_route[@stations_in_route.find_index(station).next]
  end

  def get_prev_station(station)
    @stations_in_route[@stations_in_route.find_index(station).prev] if @stations_in_route.find_index(station) > 0
  end
  
end
