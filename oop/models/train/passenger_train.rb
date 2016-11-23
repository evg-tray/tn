require_relative '../wagon/passenger_wagon'
class PassengerTrain < Train
  TYPE = 'Пассажирский'.freeze
  TYPE_WAGON = PassengerWagon
end
