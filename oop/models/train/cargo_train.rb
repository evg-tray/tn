require_relative '../wagon/cargo_wagon'
class CargoTrain < Train
  TYPE = 'Грузовой'.freeze
  TYPE_WAGON = CargoWagon
end
